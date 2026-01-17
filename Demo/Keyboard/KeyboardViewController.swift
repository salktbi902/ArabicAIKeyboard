//
//  KeyboardViewController.swift
//  KeyboardPro
//
//  Created by Daniel Saidi on 2023-02-13.
//  Copyright © 2023-2025 Daniel Saidi. All rights reserved.
//
//  ✨ Modified for Arabic AI Keyboard with Gemini API
//

import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    deinit {
        NSLog("__DEINIT__")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// إعداد الكيبورد مع تطبيق Demo
        setup(for: .keyboardKitDemo) { [weak self] result in
            switch result {
            case .success:
                self?.setupDemoServices()
                self?.setupDemoState()
                self?.setupArabicLocale()  // ✨ إضافة جديدة
            case .failure(let error):
                print(error)
            }
        }
    }

    override func viewWillSetupKeyboardView() {
        /// إعداد واجهة الكيبورد المخصصة مع AI Toolbar
        setupKeyboardView { controller in
            DemoKeyboardView(
                services: controller.services,
                state: controller.state
            )
        }
    }
}

private extension KeyboardViewController {

    /// إعداد الخدمات (Action Handler)
    func setupDemoServices() {
        services.actionHandler = DemoActionHandler(
            controller: self
        )
    }

    /// إعداد حالة الكيبورد (اللغة والأزرار)
    func setupDemoState() {
        state.keyboardContext.localePresentationLocale = .current
        
        /// إعدادات زر المسافة والاهتزاز
        state.keyboardContext.settings.spacebarLongPressBehavior = .moveInputCursor
        state.keyboardContext.settings.spacebarMenuTrailing = .locale
        
        let feedback = state.feedbackContext
        feedback.registerCustomFeedback(.haptic(.selectionChanged, for: .repeat, on: .rocket))
    }
    
    /// ✨ إعداد اللغة العربية كلغة أساسية
    func setupArabicLocale() {
        let arabicLocale = Locale(identifier: "ar")
        
        if state.keyboardContext.locales.contains(where: { $0.identifier.hasPrefix("ar") }) {
            state.keyboardContext.locale = arabicLocale
        }
        
        state.keyboardContext.localePresentationLocale = arabicLocale
        state.keyboardContext.keyboardType = .alphabetic
        
        NSLog("✅ Arabic locale configured successfully")
    }
}
