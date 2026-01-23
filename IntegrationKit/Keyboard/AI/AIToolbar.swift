//
//  AIToolbar.swift
//  Arabic AI Keyboard
//
//  ✨ شريط أدوات الذكاء الاصطناعي - نسخة مبسطة
//

import SwiftUI
import KeyboardKit

/// شريط أدوات AI للكيبورد
struct AIToolbar: View {
    
    var keyboardContext: KeyboardContext
    @StateObject private var geminiService = GeminiService.shared
    @State private var processingCommand: AICommand?
    @State private var showAllCommands = false
    
    var body: some View {
        VStack(spacing: 0) {
            // الصف الأول - الأوامر الأساسية
            HStack(spacing: 6) {
                quickButton(.proofread)
                quickButton(.translate)
                quickButton(.diacritics)
                quickButton(.improve)
                
                Spacer()
                
                // زر المزيد
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showAllCommands.toggle()
                    }
                } label: {
                    Image(systemName: showAllCommands ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .bold))
                        .frame(width: 36, height: 36)
                        .background(Color.secondary.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
                
                // مؤشر المعالجة
                if geminiService.isProcessing {
                    ProgressView()
                        .scaleEffect(0.7)
                        .frame(width: 30)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            
            // الصف الثاني - أوامر إضافية
            if showAllCommands {
                HStack(spacing: 6) {
                    quickButton(.summarize)
                    quickButton(.expand)
                    quickButton(.formal)
                    quickButton(.casual)
                    quickButton(.reply)
                    quickButton(.complete)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 4)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    /// زر سريع
    func quickButton(_ command: AICommand) -> some View {
        Button {
            executeCommand(command)
        } label: {
            VStack(spacing: 1) {
                Image(systemName: command.icon)
                    .font(.system(size: 14, weight: .medium))
                Text(command.titleAr)
                    .font(.system(size: 9, weight: .medium))
            }
            .frame(width: 44, height: 36)
            .background(buttonColor(command).opacity(0.15))
            .foregroundColor(buttonColor(command))
            .cornerRadius(6)
        }
        .disabled(processingCommand != nil)
        .opacity(processingCommand == command ? 0.5 : 1.0)
    }
    
    /// لون الزر
    func buttonColor(_ command: AICommand) -> Color {
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
    
    /// تنفيذ الأمر
    func executeCommand(_ command: AICommand) {
        let proxy = keyboardContext.textDocumentProxy
        
        // الحصول على النص
        var text = ""
        if let selected = proxy.selectedText, !selected.isEmpty {
            text = selected
        } else if let before = proxy.documentContextBeforeInput {
            // أخذ آخر جملة أو كل النص
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let last = sentences.last?.trimmingCharacters(in: .whitespaces), !last.isEmpty {
                text = last
            } else {
                text = before
            }
        }
        
        guard !text.isEmpty else {
            // اهتزاز خطأ
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            return
        }
        
        processingCommand = command
        
        // اهتزاز بداية
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        Task {
            if let result = await geminiService.process(text, command: command) {
                await MainActor.run {
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
                    proxy.insertText(result)
                    
                    // اهتزاز نجاح
                    let successGenerator = UINotificationFeedbackGenerator()
                    successGenerator.notificationOccurred(.success)
                }
            } else {
                // اهتزاز فشل
                await MainActor.run {
                    let errorGenerator = UINotificationFeedbackGenerator()
                    errorGenerator.notificationOccurred(.error)
                }
            }
            
            await MainActor.run {
                processingCommand = nil
            }
        }
    }
}
