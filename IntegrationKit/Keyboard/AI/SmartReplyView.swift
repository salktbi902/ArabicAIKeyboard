//
//  SmartReplyView.swift
//  Arabic AI Keyboard
//
//  ✨ واجهة عرض الردود الذكية
//  تعرض اقتراحات الردود في شريط أفقي قابل للتمرير
//

import SwiftUI
import KeyboardKit

// MARK: - شريط الردود الذكية

/// شريط الردود الذكية الذي يظهر فوق الكيبورد
struct SmartReplyBar: View {
    
    @ObservedObject var replyService: SmartReplyService
    let onReplySelected: (String) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // شريط العنوان
            HStack {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .foregroundColor(.blue)
                Text("ردود مقترحة")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                if replyService.isLoading {
                    ProgressView()
                        .scaleEffect(0.7)
                }
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.secondary.opacity(0.1))
            
            // شريط الردود
            if replyService.isLoading {
                loadingView
            } else if !replyService.replies.isEmpty {
                repliesScrollView
            } else if let error = replyService.lastError {
                errorView(error)
            }
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: -2)
    }
    
    // MARK: - Views
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Text("جارٍ توليد الردود...")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
    
    private var repliesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(replyService.replies) { reply in
                    SmartReplyButton(reply: reply) {
                        onReplySelected(reply.text)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
    
    private func errorView(_ error: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text(error)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

// MARK: - زر الرد الذكي

struct SmartReplyButton: View {
    
    let reply: SmartReply
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(reply.tone.emoji)
                    .font(.caption)
                Text(reply.text)
                    .font(.subheadline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(toneColor.opacity(0.15))
            .foregroundColor(toneColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(toneColor.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var toneColor: Color {
        switch reply.tone {
        case .positive: return .green
        case .neutral: return .gray
        case .formal: return .blue
        case .friendly: return .orange
        }
    }
}

// MARK: - شريط الردود المدمج في Toolbar

/// شريط الردود الذكية المدمج في شريط الأدوات
struct SmartReplyToolbar: View {
    
    @StateObject private var replyService = SmartReplyService.shared
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @State private var isExpanded = false
    @State private var lastProcessedText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            if isExpanded && !replyService.replies.isEmpty {
                SmartReplyBar(
                    replyService: replyService,
                    onReplySelected: { reply in
                        insertReply(reply)
                    },
                    onDismiss: {
                        withAnimation {
                            isExpanded = false
                            replyService.clearReplies()
                        }
                    }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // زر تفعيل الردود الذكية
            smartReplyToggleButton
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
    
    private var smartReplyToggleButton: some View {
        Button {
            if isExpanded {
                withAnimation {
                    isExpanded = false
                    replyService.clearReplies()
                }
            } else {
                generateReplies()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: isExpanded ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right")
                    .font(.caption)
                Text("ردود ذكية")
                    .font(.caption2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isExpanded ? Color.blue : Color.secondary.opacity(0.2))
            .foregroundColor(isExpanded ? .white : .primary)
            .cornerRadius(12)
        }
        .disabled(replyService.isLoading)
    }
    
    // MARK: - Actions
    
    private func generateReplies() {
        let proxy = keyboardContext.textDocumentProxy
        
        // الحصول على النص (الرسالة المستلمة)
        var messageText = ""
        
        // نحاول الحصول على النص من قبل المؤشر
        if let before = proxy.documentContextBeforeInput {
            // نأخذ آخر جملة أو رسالة
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let lastSentence = sentences.last?.trimmingCharacters(in: .whitespaces), !lastSentence.isEmpty {
                messageText = lastSentence
            } else if sentences.count > 1, let prevSentence = sentences.dropLast().last?.trimmingCharacters(in: .whitespaces) {
                messageText = prevSentence
            } else {
                messageText = before.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        guard !messageText.isEmpty, messageText != lastProcessedText else {
            // إذا كان النص فارغ أو نفس النص السابق، نعرض الردود الموجودة
            if !replyService.replies.isEmpty {
                withAnimation {
                    isExpanded = true
                }
            }
            return
        }
        
        lastProcessedText = messageText
        
        withAnimation {
            isExpanded = true
        }
        
        Task {
            _ = await replyService.generateSmartReplies(for: messageText)
        }
    }
    
    private func insertReply(_ reply: String) {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(reply)
        
        withAnimation {
            isExpanded = false
            replyService.clearReplies()
        }
    }
}

// MARK: - قائمة الردود الكاملة

/// قائمة الردود الذكية الكاملة (تظهر كـ Sheet)
struct SmartReplySheet: View {
    
    @Binding var isPresented: Bool
    @StateObject private var replyService = SmartReplyService.shared
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @State private var inputMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // حقل إدخال الرسالة
                VStack(alignment: .leading, spacing: 8) {
                    Text("الرسالة المستلمة:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("أدخل الرسالة للحصول على ردود مقترحة...", text: $inputMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                        .environment(\.layoutDirection, .rightToLeft)
                }
                .padding(.horizontal)
                
                // زر التوليد
                Button {
                    Task {
                        _ = await replyService.generateSmartReplies(for: inputMessage)
                    }
                } label: {
                    HStack {
                        if replyService.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "sparkles")
                        }
                        Text("توليد ردود ذكية")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(inputMessage.isEmpty || replyService.isLoading)
                .padding(.horizontal)
                
                // قائمة الردود
                if !replyService.replies.isEmpty {
                    List {
                        Section("الردود المقترحة") {
                            ForEach(replyService.replies) { reply in
                                SmartReplyRow(reply: reply) {
                                    insertReply(reply.text)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                } else if let error = replyService.lastError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("أدخل رسالة للحصول على ردود مقترحة")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                }
                
                Spacer()
            }
            .navigationTitle("الردود الذكية")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("إغلاق") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            loadCurrentMessage()
        }
    }
    
    private func loadCurrentMessage() {
        let proxy = keyboardContext.textDocumentProxy
        if let before = proxy.documentContextBeforeInput {
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let lastSentence = sentences.last?.trimmingCharacters(in: .whitespaces), !lastSentence.isEmpty {
                inputMessage = lastSentence
            }
        }
    }
    
    private func insertReply(_ reply: String) {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(reply)
        isPresented = false
    }
}

// MARK: - صف الرد في القائمة

struct SmartReplyRow: View {
    
    let reply: SmartReply
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(reply.tone.emoji)
                        Text(reply.tone.titleAr)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(reply.text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Smart Reply Bar") {
    VStack {
        Spacer()
        SmartReplyBar(
            replyService: {
                let service = SmartReplyService.shared
                return service
            }(),
            onReplySelected: { _ in },
            onDismiss: {}
        )
    }
    .background(Color.gray.opacity(0.2))
}

#Preview("Smart Reply Sheet") {
    SmartReplySheet(isPresented: .constant(true))
}
