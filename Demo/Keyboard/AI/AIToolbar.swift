//
//  AIToolbar.swift
//  Arabic AI Keyboard
//
//  ✨ شريط أدوات الذكاء الاصطناعي
//

import SwiftUI
import KeyboardKit

/// شريط أدوات AI للكيبورد
struct AIToolbar: View {
    
    @EnvironmentObject var keyboardContext: KeyboardContext
    @StateObject private var geminiService = GeminiService.shared
    @State private var processingCommand: AICommand?
    
    var body: some View {
        HStack(spacing: 8) {
            // الأوامر السريعة
            quickButton(.proofread)
            quickButton(.translate)
            quickButton(.diacritics)
            quickButton(.improve)
            
            Spacer()
            
            // مؤشر المعالجة
            if geminiService.isProcessing {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.secondary.opacity(0.1))
    }
    
    /// زر سريع
    func quickButton(_ command: AICommand) -> some View {
        Button {
            executeCommand(command)
        } label: {
            VStack(spacing: 2) {
                Image(systemName: command.icon)
                    .font(.system(size: 16, weight: .medium))
                Text(command.titleAr)
                    .font(.system(size: 10))
            }
            .frame(width: 50, height: 40)
            .background(buttonColor(command).opacity(0.15))
            .foregroundColor(buttonColor(command))
            .cornerRadius(8)
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
        default: return .blue
        }
    }
    
    /// تنفيذ الأمر
    func executeCommand(_ command: AICommand) {
        guard let proxy = keyboardContext.textDocumentProxy else { return }
        
        // الحصول على النص
        var text = ""
        if let selected = proxy.selectedText, !selected.isEmpty {
            text = selected
        } else if let before = proxy.documentContextBeforeInput {
            // أخذ آخر جملة
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let last = sentences.last?.trimmingCharacters(in: .whitespaces), !last.isEmpty {
                text = last
            } else {
                text = before
            }
        }
        
        guard !text.isEmpty else { return }
        
        processingCommand = command
        
        // اهتزاز
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
            }
            
            await MainActor.run {
                processingCommand = nil
            }
        }
    }
}

#Preview {
    AIToolbar()
        .background(Color.gray.opacity(0.2))
}
