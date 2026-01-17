//
//  DemoKeyboardView.swift
//  KeyboardPro
//
//  Created by Daniel Saidi on 2022-02-04.
//  Copyright © 2022-2025 Daniel Saidi. All rights reserved.
//
//  ✨ Modified for Arabic AI Keyboard
//

import KeyboardKit
import SwiftUI

/// This demo-specific keyboard view sets up a `KeyboardView`
/// and customizes it with Pro features + AI Toolbar.
struct DemoKeyboardView: View {

    var services: Keyboard.Services
    var state: Keyboard.State

    @AppStorage("com.keyboardkit.demo.isToolbarToggled")
    var isToolbarToggled = false

    @EnvironmentObject var themeContext: KeyboardThemeContext

    @State var activeSheet: DemoSheet?
    @State var isTextInputActive = false
    @State var theme: KeyboardTheme?
    @State var showAIToolbar = true

    var keyboardContext: KeyboardContext { state.keyboardContext }

    var body: some View {
        VStack(spacing: 0) {
            // ✨ شريط أدوات AI في الأعلى
            if showAIToolbar && !isToolbarToggled {
                AIToolbar(keyboardContext: keyboardContext)
            }
            
            // لوحة المفاتيح الأصلية
            KeyboardView(
                layout: demoLayout,
                services: services,
                buttonContent: { $0.view },
                buttonView: {
                    $0.view.opacity(isToolbarToggled ? 0 : 1)
                },
                collapsedView: { $0.view },
                emojiKeyboard: { $0.view },
                toolbar: { params in
                    if isTextInputActive {
                        DemoTextInputToolbar(
                            isTextInputActive: $isTextInputActive
                        )
                    } else {
                        DemoToolbar(
                            services: services,
                            toolbar: params.view,
                            isTextInputActive: $isTextInputActive,
                            isToolbarToggled: $isToolbarToggled
                        )
                    }
                }
            )
            .overlay(menuGrid)
            .animation(.bouncy, value: isToolbarToggled)
        }

        .keyboardCalloutActions { params in
            if case .character(let char) = params.action, char == "K" {
                return .init(characters: String("keyboardkit".reversed()))
            }
            return params.standardActions()
        }

        .keyboardTheme(
            themeContext.currentTheme
        )

        .sheet(item: $activeSheet) { sheet in
            NavigationStack {
                sheetContent
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Button.Done") {
                                activeSheet = nil
                            }
                        }
                    }
            }
        }
    }
}

private extension DemoKeyboardView {

    var demoLayout: KeyboardLayout {
        NSLog("Creating a custom layout")
        var layout = KeyboardLayout.standard(for: keyboardContext)
        guard keyboardContext.keyboardType == .alphabetic else { return layout }
        var item = layout.createIdealItem(for: .rocket)
        item.size.width = .input
        layout.itemRows.insert(item, after: .space)
        return layout
    }

    @ViewBuilder var menuGrid: some View {
        if isToolbarToggled {
            DemoKeyboardMenu(
                actionHandler: services.actionHandler,
                isTextInputActive: $isTextInputActive,
                isToolbarToggled: $isToolbarToggled,
                sheet: $activeSheet
            )
            .padding(.top, 55)
            .padding(.horizontal, 10)
            .transition(.move(edge: .bottom))
        }
    }

    @ViewBuilder var sheetContent: some View {
        switch activeSheet {
        case .fullDocumentReader:
            FullDocumentContextSheet()
        case .hostApplicationInfo:
            HostAppInfoSheet(actionHandler: services.actionHandler)
        case .keyboardSettings:
            Keyboard.SettingsScreen()
        case .localeSettings:
            Keyboard.LocaleSettingsScreen()
        case .themeSettings:
            KeyboardTheme.SettingsScreen()
        case .none: EmptyView()
        }
    }
}
