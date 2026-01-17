//
//  AIMenu.swift
//  ArabicAIKeyboard
//
//  قائمة الذكاء الاصطناعي الكاملة
//  Created for Arabic AI Keyboard Enhancement
//

import SwiftUI
import KeyboardKit

/// قائمة الذكاء الاصطناعي
struct AIMenu: View {
    
    let actionHandler: KeyboardActionHandler
    
    @Binding var isPresented: Bool
    
    @StateObject private var geminiService = GeminiService.shared
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @State private var processingCommand: AICommand?
    @State private var showResult = false
    @State private var resultText = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                // العنوان
                headerView
                
                // شبكة الأوامر
                commandsGrid
                
                // نتيجة المعالجة
                if showResult {
                    resultView
                }
            }
            .padding()
        }
        .background(Color.clearInteractable)
    }
    
    // MARK: - Views
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("🤖 الذكاء الاصطناعي")
                    .font(.headline)
                Text("اختر أمراً لمعالجة النص")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    isPresented = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var commandsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 80, maximum: 120))
        ], spacing: 12) {
            ForEach(AICommand.allCases) { command in
                AIMenuButton(
                    command: command,
                    isProcessing: processingCommand == command,
                    action: { executeCommand(command) }
                )
            }
        }
    }
    
    private var resultView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("النتيجة:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(resultText)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            
            HStack {
                Button("نسخ") {
                    UIPasteboard.general.string = resultText
                }
                .buttonStyle(.bordered)
                
                Button("إدراج") {
                    insertResult()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Actions
    
    private func executeCommand(_ command: AICommand) {
        let proxy = keyboardContext.textDocumentProxy
        guard let text = getCurrentText(from: proxy),
              !text.isEmpty else {
            return
        }
        
        processingCommand = command
        showResult = false
        
        Task {
            if let result = await geminiService.process(text, command: command) {
                await MainActor.run {
                    resultText = result
                    showResult = true
                }
            }
            
            await MainActor.run {
                processingCommand = nil
            }
        }
    }
    
    private func getCurrentText(from proxy: UITextDocumentProxy) -> String? {
        if let selected = proxy.selectedText, !selected.isEmpty {
            return selected
        }
        
        if let before = proxy.documentContextBeforeInput {
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let last = sentences.last?.trimmingCharacters(in: .whitespaces), !last.isEmpty {
                return last
            }
            return before
        }
        
        return nil
    }
    
    private func insertResult() {
        let proxy = keyboardContext.textDocumentProxy
        
        // حذف النص القديم
        if let before = proxy.documentContextBeforeInput {
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let last = sentences.last?.trimmingCharacters(in: .whitespaces), !last.isEmpty {
                for _ in 0..<last.count {
                    proxy.deleteBackward()
                }
            }
        }
        
        // إدراج النتيجة
        proxy.insertText(resultText)
        
        // إغلاق القائمة
        withAnimation {
            isPresented = false
            showResult = false
        }
    }
}

/// زر قائمة الذكاء الاصطناعي
struct AIMenuButton: View {
    
    let command: AICommand
    let isProcessing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    if isProcessing {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: command.icon)
                            .font(.title2)
                    }
                }
                .frame(width: 30, height: 30)
                
                Text(command.titleAr)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(buttonColor.opacity(0.15))
            .foregroundColor(buttonColor)
            .cornerRadius(12)
        }
        .disabled(isProcessing)
        .opacity(isProcessing ? 0.6 : 1.0)
    }
    
    private var buttonColor: Color {
        switch command.color {
        case "blue": return .blue
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "indigo": return .indigo
        case "teal": return .teal
        case "gray": return .gray
        case "pink": return .pink
        case "cyan": return .cyan
        case "mint": return .mint
        default: return .blue
        }
    }
}

#Preview {
    AIMenu(
        actionHandler: .preview,
        isPresented: .constant(true)
    )
    .background(Color.keyboardBackground)
}
