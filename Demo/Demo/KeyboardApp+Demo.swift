//
//  KeyboardApp+Demo.swift
//  Demo
//
//  Created by Daniel Saidi on 2024-08-19.
//  Copyright © 2024-2025 Daniel Saidi. All rights reserved.
//
//  Modified for Arabic AI Keyboard Enhancement
//

#if IS_KEYBOARDKIT
import KeyboardKit
#else
import KeyboardKit
#endif

extension KeyboardApp {

    /// This `KeyboardApp` value defines the demo app.
    ///
    /// The demo uses a `KeyboardKit.license` file to unlock
    /// KeyboardKit Pro, without having to include a license
    /// key in the app information below. This also lets the
    /// app update its license without also having to update
    /// KeyboardKit version. Note that this file is added to
    /// both the app and the `KeyboardPro` keyboard.
    ///
    /// The App Group ID is only to show you how you can use
    /// a `KeyboardApp` to set up App Group data syncing for
    /// an app and its keyboard. It doesn't work in the demo.
    /// 
    /// See `DemoApp.swift` for more info about the demo app.
    static var keyboardKitDemo: KeyboardApp {
        .init(
            name: "Arabic AI Keyboard",
            licenseKey: "CC58DE28-A7424BC5-AE833050-EF7D988B",   // KeyboardKit Pro License
            appGroupId: "group.com.arabicaikeyboard.app",        // App Group for data sync
            locales: .arabicFirst,                               // Arabic as primary locale
            autocomplete: .init(
                // nextWordPredictionRequest: .claude(apiKey: "")
            ),
            deepLinks: .init(
                app: "arabicai://"                               // Deep link scheme
            )
        )
    }
}

// MARK: - Locale Extensions

extension Array where Element == Locale {
    
    /// اللغات المدعومة مع العربية كأولوية
    static var arabicFirst: [Locale] {
        [
            Locale(identifier: "ar"),           // العربية
            Locale(identifier: "ar_SA"),        // العربية (السعودية)
            Locale(identifier: "ar_AE"),        // العربية (الإمارات)
            Locale(identifier: "ar_EG"),        // العربية (مصر)
            Locale(identifier: "en"),           // الإنجليزية
            Locale(identifier: "en_US"),        // الإنجليزية (أمريكا)
            Locale(identifier: "en_GB"),        // الإنجليزية (بريطانيا)
            Locale(identifier: "fr"),           // الفرنسية
            Locale(identifier: "tr"),           // التركية
            Locale(identifier: "ur"),           // الأردية
            Locale(identifier: "fa"),           // الفارسية
        ]
    }
}
