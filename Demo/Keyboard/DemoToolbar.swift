//
//  DemoToolbar.swift
//  KeyboardPro
//
//  Created by Daniel Saidi on 2023-11-27.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//
//  Modified for Arabic AI Keyboard Enhancement
//

import KeyboardKit
import SwiftUI

/// This demo-specific toolbar is used as the `ToggleToolbar`
/// toggled view in ``DemoKeyboardView``.
///
/// This toolbar has a textfield to let you type and buttons
/// to toggle state, trigger actions, etc.
struct DemoToolbar<Toolbar: View>: View {

    var services: Keyboard.Services
    var toolbar: Toolbar

    @Binding var isTextInputActive: Bool
    @Binding var isToolbarToggled: Bool

    @EnvironmentObject var autocompleteContext: AutocompleteContext
    @EnvironmentObject var feedbackContext: FeedbackContext
    @EnvironmentObject var keyboardContext: KeyboardContext

    @FocusState var isTextFieldFocused

    @State var fullDocumentContext = ""
    @State var isThemePickerPresented = false
    @State var isFullDocumentContextActive = false
    @State var text = ""
    @State var isAIExpanded = false
    
    @StateObject private var geminiService = GeminiService.shared
    @State private var processingCommand: AICommand?

    var body: some View {
        try? Keyboard.ToggleToolbar(
            isToggled: $isToolbarToggled,
            toolbar: aiEnhancedToolbar,                     // شريط أدوات محسن مع AI
            toggledToolbar: toggledToolbar
        )
        .tint(.primary)
        .font(.title3)
        .buttonStyle(.plainKeyboard)
        .padding(.trailing)
    }
}

private extension DemoToolbar {

    var aiEnhancedToolbar: some View {
        HStack(spacing: 8) {
            // أزرار AI السريعة
            aiQuickButtons
            
            // شريط الإكمال التلقائي
            toolbar.frame(maxWidth: .infinity)
            
            // زر تبديل اللغة
            localeSwitcher
        }
    }
    
    /// أزرار AI السريعة
    var aiQuickButtons: some View {
        HStack(spacing: 4) {
            // زر التدقيق
            quickAIButton(.proofread)
            
            // زر الترجمة
            quickAIButton(.translate)
            
            // زر التشكيل
            quickAIButton(.diacritics)
        }
    }
    
    /// زر AI سريع
    func quickAIButton(_ command: AICommand) -> some View {
        Button {
            executeQuickAI(command)
        } label: {
            ZStack {
                if processingCommand == command {
                    ProgressView()
                        .scaleEffect(0.6)
                } else {
                    Image(systemName: command.icon)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .frame(width: 28, height: 28)
            .background(Color.secondary.opacity(0.15))
            .cornerRadius(6)
        }
        .disabled(processingCommand != nil)
        .opacity(processingCommand == command ? 0.6 : 1.0)
    }
    
    /// تنفيذ أمر AI سريع
    func executeQuickAI(_ command: AICommand) {
        guard let proxy = keyboardContext.textDocumentProxy else { return }
        
        // الحصول على النص
        var text = ""
        if let selected = proxy.selectedText, !selected.isEmpty {
            text = selected
        } else if let before = proxy.documentContextBeforeInput {
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
        
        // تشغيل اهتزاز
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

    var autocompleteToolbar: some View {
        HStack {
            toolbar.frame(maxWidth: .infinity)
            localeSwitcher
        }
    }

    var toggledToolbar: some View {
        HStack {
            Spacer()
            Button {
                keyboardContext.isKeyboardCollapsed.toggle()
            } label: {
                Image.keyboardDismiss
            }
        }
    }
}

private extension DemoToolbar {

    var localeSwitcher: some View {
        Image.keyboardGlobe
            .background(Color.clearInteractable)
            .localeContextMenu {
                services.actionHandler.handle(.nextLocale)
            }
    }
}
