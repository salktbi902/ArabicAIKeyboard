//
//  AIToolbar.swift
//  ArabicAIKeyboard
//
//  شريط أدوات الذكاء الاصطناعي
//  Created for Arabic AI Keyboard Enhancement
//

import SwiftUI
import KeyboardKit

/// شريط أدوات الذكاء الاصطناعي
struct AIToolbar: View {
    
    let actionHandler: KeyboardActionHandler
    
    @Binding var isExpanded: Bool
    
    @StateObject private var geminiService = GeminiService.shared
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @State private var processingCommand: AICommand?
    
    /// الأوامر الأساسية المعروضة دائماً
    let primaryCommands: [AICommand] = [.proofread, .translate, .diacritics, .improve]
    
    /// الأوامر الإضافية
    let secondaryCommands: [AICommand] = [.summarize, .expand, .formal, .casual, .reply, .complete]
    
    var body: some View {
        VStack(spacing: 8) {
            // الصف الأول - الأوامر الأساسية
            HStack(spacing: 8) {
                ForEach(primaryCommands) { command in
                    AICommandButton(
                        command: command,
                        isProcessing: processingCommand == command,
                        action: { executeCommand(command) }
                    )
                }
                
                // زر التوسيع
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            // الصف الثاني - الأوامر الإضافية (عند التوسيع)
            if isExpanded {
                HStack(spacing: 8) {
                    ForEach(secondaryCommands) { command in
                        AICommandButton(
                            command: command,
                            isProcessing: processingCommand == command,
                            action: { executeCommand(command) }
                        )
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
    
    /// تنفيذ الأمر
    private func executeCommand(_ command: AICommand) {
        // الحصول على النص الحالي
        guard let proxy = keyboardContext.textDocumentProxy,
              let text = getCurrentText(from: proxy),
              !text.isEmpty else {
            return
        }
        
        processingCommand = command
        
        Task {
            if let result = await geminiService.process(text, command: command) {
                // استبدال النص
                await MainActor.run {
                    replaceText(in: proxy, with: result)
                }
            }
            
            await MainActor.run {
                processingCommand = nil
            }
        }
    }
    
    /// الحصول على النص الحالي
    private func getCurrentText(from proxy: UITextDocumentProxy) -> String? {
        // محاولة الحصول على النص المحدد
        if let selected = proxy.selectedText, !selected.isEmpty {
            return selected
        }
        
        // الحصول على النص قبل المؤشر
        if let before = proxy.documentContextBeforeInput {
            // البحث عن آخر جملة
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let last = sentences.last?.trimmingCharacters(in: .whitespaces), !last.isEmpty {
                return last
            }
            return before
        }
        
        return nil
    }
    
    /// استبدال النص
    private func replaceText(in proxy: UITextDocumentProxy, with newText: String) {
        // حذف النص الحالي
        if let before = proxy.documentContextBeforeInput {
            let separators = CharacterSet(charactersIn: ".!?؟。\n")
            let sentences = before.components(separatedBy: separators)
            if let last = sentences.last?.trimmingCharacters(in: .whitespaces), !last.isEmpty {
                for _ in 0..<last.count {
                    proxy.deleteBackward()
                }
            }
        }
        
        // إدراج النص الجديد
        proxy.insertText(newText)
    }
}

/// زر أمر الذكاء الاصطناعي
struct AICommandButton: View {
    
    let command: AICommand
    let isProcessing: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                ZStack {
                    if isProcessing {
                        ProgressView()
                            .scaleEffect(0.7)
                    } else {
                        Image(systemName: command.icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .frame(width: 20, height: 20)
                
                Text(command.titleAr)
                    .font(.system(size: 9, weight: .medium))
                    .lineLimit(1)
            }
            .frame(minWidth: 44, minHeight: 44)
            .background(buttonBackground)
            .foregroundColor(buttonForeground)
            .cornerRadius(10)
        }
        .disabled(isProcessing)
        .opacity(isProcessing ? 0.6 : 1.0)
    }
    
    private var buttonBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.06)
    }
    
    private var buttonForeground: Color {
        colorScheme == .dark ? .white : .primary
    }
}

#Preview {
    AIToolbar(
        actionHandler: .preview,
        isExpanded: .constant(false)
    )
    .padding()
    .background(Color.keyboardBackground)
}
