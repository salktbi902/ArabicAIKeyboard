//
//  DemoKeyboardMenu.swift
//  Demo
//
//  Created by Daniel Saidi on 2024-11-24.
//  Copyright © 2024-2025 Daniel Saidi. All rights reserved.
//
//  Modified for Arabic AI Keyboard Enhancement
//

import SwiftUI
import KeyboardKit

/// This menu is used when the main toolbar toggle is tapped
/// to present an alternate toolbar.
///
/// The file is added to the app as well, to enable previews.
struct DemoKeyboardMenu: View {
    
    let actionHandler: KeyboardActionHandler

    @Binding var isTextInputActive: Bool
    @Binding var isToolbarToggled: Bool
    @Binding var sheet: DemoSheet?

    let app = KeyboardApp.keyboardKitDemo
    
    // let docUrl = "https://keyboardkit.github.io/KeyboardKitPro/documentation/keyboardkitpro/"
    let webUrl = "https://keyboardkit.com"

    @EnvironmentObject var autocompleteContext: AutocompleteContext
    @EnvironmentObject var dictationContext: DictationContext
    @EnvironmentObject var feedbackContext: FeedbackContext
    @EnvironmentObject var keyboardContext: KeyboardContext
    @EnvironmentObject var themeContext: KeyboardThemeContext
    
    @State private var showAIMenu = false
    @State private var showSmartReplySheet = false
    @State private var showCodeToolsMenu = false
    @State private var showProgrammerKeyboard = false
    @StateObject private var geminiService = GeminiService.shared
    @StateObject private var smartReplyService = SmartReplyService.shared
    @StateObject private var codeService = CodeService.shared
    @State private var processingCommand: AICommand?

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [
                .init(.adaptive(minimum: 115, maximum: 600))
            ]) {
                menuContent()
            }
            .padding(.bottom, 10)
            .background(Color.clearInteractable)            // Needed in keyboard extensions
        }
        .sheet(isPresented: $showAIMenu) {
            AIMenu(
                actionHandler: actionHandler,
                isPresented: $showAIMenu
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showSmartReplySheet) {
            SmartReplySheet(isPresented: $showSmartReplySheet)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showCodeToolsMenu) {
            CodeToolsMenu(isPresented: $showCodeToolsMenu)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showProgrammerKeyboard) {
            ProgrammerKeyboardSheet(isPresented: $showProgrammerKeyboard)
                .presentationDetents([.medium])
        }
    }
}

extension DemoKeyboardMenu {

    @ViewBuilder
    func menuContent() -> some View {
        
        // ⭐ قسم الذكاء الاصطناعي - جديد
        aiSection
        
        // 💻 قسم أدوات البرمجة - جديد
        codeSection
        
        // القائمة الأصلية
        menuItem(
            title: "Menu.Settings",
            icon: .keyboardSettings,
            tint: .primary,
            action: { sheet = .keyboardSettings }
        )

        menuItem(
            title: "Menu.Languages",
            icon: .keyboardGlobe,
            tint: .blue,
            action: { sheet = .localeSettings }
        )

        menuItem(
            title: "Menu.Themes",
            icon: .keyboardTheme,
            tint: .pink,
            iconShadow: true,
            action: { sheet = .themeSettings }
        )

        menuItem(
            title: "Menu.Dictation",
            icon: .keyboardDictation,
            tint: .orange,
            action: { actionHandler.handle(.dictation) }
        )

        menuItem(
            title: "Menu.TextInput",
            icon: .init(systemName: "square.and.pencil"),
            tint: .teal,
            action: { isTextInputActive.toggle() }
        )

        menuItem(
            title: "Menu.ReadFullDocument",
            icon: .init(systemName: "doc.text.magnifyingglass"),
            tint: .indigo,
            action: { sheet = .fullDocumentReader }
        )

        menuItem(
            title: "Menu.HostApp",
            icon: .init(systemName: "lightbulb"),
            tint: .primary.opacity(0.5),
            iconTint: .yellow,
            action: { sheet = .hostApplicationInfo }
        )

        menuItem(
            title: "Menu.OpenApp",
            icon: .init(systemName: "apps.iphone"),
            tint: .purple,
            action: { tryOpenUrl(app.deepLinks?.app) }
        )
        
        menuItem(
            title: "Menu.OpenWebsite",
            icon: .init(systemName: "safari"),
            tint: .blue,
            action: { tryOpenUrl(webUrl) }
        )
        
        menuItem(
            title: "Menu.CloseMenu",
            icon: .init(systemName: "xmark"),
            tint: .primary,
            iconTint: .primary,
            action: {}
        )
    }
    
    // MARK: - AI Section
    
    /// قسم الذكاء الاصطناعي
    @ViewBuilder
    var aiSection: some View {
        // زر فتح قائمة AI الكاملة
        aiMenuItem(
            title: "🤖 الذكاء الاصطناعي",
            icon: .init(systemName: "brain"),
            tint: .purple,
            action: { showAIMenu = true }
        )
        
        // ⭐ زر الردود الذكية - جديد
        smartReplyMenuItem
        
        // الأوامر السريعة
        aiCommandItem(.proofread)
        aiCommandItem(.translate)
        aiCommandItem(.diacritics)
        aiCommandItem(.improve)
    }
    
    // MARK: - Code Section
    
    /// قسم أدوات البرمجة
    @ViewBuilder
    var codeSection: some View {
        // زر فتح قائمة أدوات البرمجة
        codeMenuItem(
            title: "💻 أدوات البرمجة",
            icon: .init(systemName: "chevron.left.forwardslash.chevron.right"),
            tint: .indigo,
            action: { showCodeToolsMenu = true }
        )
        
        // زر لوحة المفاتيح البرمجية
        codeMenuItem(
            title: "⌨️ رموز برمجية",
            icon: .init(systemName: "curlybraces"),
            tint: .teal,
            action: { showProgrammerKeyboard = true }
        )
        
        // أوامر الكود السريعة
        codeCommandItem(.explain)
        codeCommandItem(.fix)
        codeCommandItem(.generate)
    }
    
    /// عنصر قائمة البرمجة
    func codeMenuItem(
        title: String,
        icon: Image,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            withAnimation {
                isToolbarToggled.toggle()
                action()
            }
        } label: {
            VStack(alignment: .center, spacing: 10) {
                menuItemIcon(.keyboardSettings)
                    .opacity(0)
                    .overlay(menuItemIcon(icon))
                    .font(.title)
                    .foregroundStyle(tint)
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
            }
            .padding(5)
            .font(.footnote)
        }
        .symbolVariant(.fill)
        .symbolRenderingMode(.multicolor)
        .buttonStyle(.bordered)
        .tint(tint.gradient)
        .background(Color.primary.colorInvert())
        .modify { content in
            if #available(iOS 26, *) {
                content.clipShape(.capsule)
            } else {
                content.clipShape(.rect(cornerRadius: 20))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
    }
    
    /// عنصر أمر كود
    func codeCommandItem(_ command: CodeCommand) -> some View {
        Button {
            withAnimation {
                isToolbarToggled.toggle()
                executeCodeCommand(command)
            }
        } label: {
            VStack(alignment: .center, spacing: 10) {
                ZStack {
                    if codeService.isProcessing {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: command.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                    }
                }
                .frame(height: 25)
                
                Text(command.titleAr)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
            }
            .padding(5)
            .font(.footnote)
        }
        .disabled(codeService.isProcessing)
        .symbolVariant(.fill)
        .symbolRenderingMode(.multicolor)
        .buttonStyle(.bordered)
        .tint(codeCommandColor(command).gradient)
        .background(Color.primary.colorInvert())
        .modify { content in
            if #available(iOS 26, *) {
                content.clipShape(.capsule)
            } else {
                content.clipShape(.rect(cornerRadius: 20))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
    }
    
    /// لون أمر الكود
    func codeCommandColor(_ command: CodeCommand) -> Color {
        switch command {
        case .explain: return .blue
        case .fix: return .red
        case .format: return .green
        case .convert: return .purple
        case .generate: return .orange
        case .complete: return .cyan
        case .optimize: return .yellow
        case .comment: return .gray
        case .test: return .indigo
        case .document: return .teal
        }
    }
    
    /// تنفيذ أمر كود
    func executeCodeCommand(_ command: CodeCommand) {
        let proxy = keyboardContext.textDocumentProxy
        
        // الحصول على النص
        var text = ""
        if let selected = proxy.selectedText, !selected.isEmpty {
            text = selected
        } else if let before = proxy.documentContextBeforeInput {
            text = before
        }
        
        guard !text.isEmpty else { return }
        
        Task {
            var result: String?
            
            switch command {
            case .explain:
                result = await codeService.explainCode(text, language: .swift)
            case .fix:
                result = await codeService.fixCode(text, language: .swift)
            case .generate:
                result = await codeService.generateCode(description: text, language: .swift)
            default:
                break
            }
            
            if let result = result {
                await MainActor.run {
                    proxy.insertText("\n\n" + result)
                }
            }
        }
    }
    
    // MARK: - Smart Reply
    
    /// زر الردود الذكية
    var smartReplyMenuItem: some View {
        Button {
            withAnimation {
                isToolbarToggled.toggle()
                showSmartReplySheet = true
            }
        } label: {
            VStack(alignment: .center, spacing: 10) {
                ZStack {
                    if smartReplyService.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                    }
                }
                .frame(height: 25)
                
                Text("ردود ذكية")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
            }
            .padding(5)
            .font(.footnote)
        }
        .disabled(smartReplyService.isLoading)
        .symbolVariant(.fill)
        .symbolRenderingMode(.multicolor)
        .buttonStyle(.bordered)
        .tint(Color.cyan.gradient)
        .background(Color.primary.colorInvert())
        .modify { content in
            if #available(iOS 26, *) {
                content.clipShape(.capsule)
            } else {
                content.clipShape(.rect(cornerRadius: 20))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
    }
    
    /// عنصر أمر AI
    func aiCommandItem(_ command: AICommand) -> some View {
        Button {
            withAnimation {
                isToolbarToggled.toggle()
                executeAICommand(command)
            }
        } label: {
            VStack(alignment: .center, spacing: 10) {
                ZStack {
                    if processingCommand == command {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: command.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                    }
                }
                .frame(height: 25)
                
                Text(command.titleAr)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
            }
            .padding(5)
            .font(.footnote)
        }
        .disabled(processingCommand != nil)
        .opacity(processingCommand == command ? 0.6 : 1.0)
        .symbolVariant(.fill)
        .symbolRenderingMode(.multicolor)
        .buttonStyle(.bordered)
        .tint(commandColor(command).gradient)
        .background(Color.primary.colorInvert())
        .modify { content in
            if #available(iOS 26, *) {
                content.clipShape(.capsule)
            } else {
                content.clipShape(.rect(cornerRadius: 20))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
    }
    
    /// لون الأمر
    func commandColor(_ command: AICommand) -> Color {
        switch command {
        case .proofread: return .blue
        case .translate: return .green
        case .diacritics: return .purple
        case .improve: return .orange
        case .summarize: return .indigo
        case .expand: return .teal
        case .formal: return .gray
        case .casual: return .pink
        case .reply: return .cyan
        case .complete: return .mint
        }
    }
    
    /// تنفيذ أمر AI
    func executeAICommand(_ command: AICommand) {
        let proxy = keyboardContext.textDocumentProxy
        
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
                }
            }
            
            await MainActor.run {
                processingCommand = nil
            }
        }
    }
    
    /// عنصر قائمة AI
    func aiMenuItem(
        title: String,
        icon: Image,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            withAnimation {
                isToolbarToggled.toggle()
                action()
            }
        } label: {
            VStack(alignment: .center, spacing: 10) {
                menuItemIcon(.keyboardSettings)
                    .opacity(0)
                    .overlay(menuItemIcon(icon))
                    .font(.title)
                    .foregroundStyle(tint)
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
            }
            .padding(5)
            .font(.footnote)
        }
        .symbolVariant(.fill)
        .symbolRenderingMode(.multicolor)
        .buttonStyle(.bordered)
        .tint(tint.gradient)
        .background(Color.primary.colorInvert())
        .modify { content in
            if #available(iOS 26, *) {
                content.clipShape(.capsule)
            } else {
                content.clipShape(.rect(cornerRadius: 20))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
    }

    func menuItem(
        title: LocalizedStringKey,
        icon: Image,
        tint: Color = .teal,
        iconTint: Color? = nil,
        iconShadow: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            withAnimation {
                isToolbarToggled.toggle()
                action()
            }
        } label: {
            VStack(alignment: .center, spacing: 10) {
                menuItemIcon(.keyboardSettings)             // Use same size
                    .opacity(0)
                    .overlay(menuItemIcon(icon))
                    .font(.title)
                    .foregroundStyle(iconTint ?? tint)
                    .shadow(color: (iconShadow ? .black.opacity(0.3) : .clear), radius: 0, x: 0, y: 1)
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(1)
            }
            .padding(5)
            .font(.footnote)
        }
        .symbolVariant(.fill)
        .symbolRenderingMode(.multicolor)
        .buttonStyle(.bordered)
        .tint(tint.gradient)
        .background(Color.primary.colorInvert())
        .modify { content in
            if #available(iOS 26, *) {
                content
                    .clipShape(.capsule)
            } else {
                content
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: 1)
    }

    func menuItemIcon(
        _ icon: Image
    ) -> some View {
        icon.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25)
    }
}

private extension DemoKeyboardMenu {

    func tryOpenUrl(_ url: String?) {
        guard let url, let url = URL(string: url) else { return }
        actionHandler.handle(.url(url))
    }
}

public extension View {
    func modify(@ViewBuilder transform: (Self) -> some View) -> some View {
        transform(self)
    }
}

#Preview {
    DemoKeyboardMenu(
        actionHandler: .preview,
        isTextInputActive: .constant(false),
        isToolbarToggled: .constant(true),
        sheet: .constant(nil)
    )
    .padding(10)
    .background(Color.keyboardBackground)
}
