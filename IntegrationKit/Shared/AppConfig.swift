//
//  AppConfig.swift
//  Arabic AI Keyboard
//
//  ⚙️ إعدادات التطبيق المشتركة
//  يُستخدم للمشاركة بين التطبيق الرئيسي والكيبورد
//

import Foundation

/// إعدادات التطبيق
struct AppConfig {
    
    // MARK: - Bundle Identifiers
    
    /// معرف التطبيق الرئيسي
    /// ⚠️ غيّر هذا لمعرف تطبيقك
    static let mainAppBundleId = "com.yourcompany.yourapp"
    
    /// معرف الكيبورد
    /// ⚠️ غيّر هذا لمعرف الكيبورد الخاص بك
    static let keyboardBundleId = "\(mainAppBundleId).keyboard"
    
    // MARK: - App Groups
    
    /// معرف App Group للمشاركة بين التطبيق والكيبورد
    /// ⚠️ غيّر هذا لمعرف App Group الخاص بك
    static let appGroupIdentifier = "group.\(mainAppBundleId)"
    
    // MARK: - API Keys
    
    /// مفتاح Gemini API
    /// ⚠️ أضف مفتاحك هنا أو استخدم طريقة أكثر أماناً
    static var geminiAPIKey: String {
        // الطريقة 1: من Environment Variable
        if let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] {
            return key
        }
        
        // الطريقة 2: من UserDefaults المشتركة
        if let key = sharedDefaults?.string(forKey: Keys.geminiAPIKey) {
            return key
        }
        
        // الطريقة 3: مفتاح ثابت (غير آمن للإنتاج)
        return "YOUR_GEMINI_API_KEY_HERE"
    }
    
    // MARK: - Shared UserDefaults
    
    /// UserDefaults المشتركة بين التطبيق والكيبورد
    static var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupIdentifier)
    }
    
    // MARK: - Keys
    
    /// مفاتيح التخزين
    struct Keys {
        static let geminiAPIKey = "gemini_api_key"
        static let selectedTheme = "selected_theme"
        static let selectedLanguage = "selected_language"
        static let isProEnabled = "is_pro_enabled"
        static let userPreferences = "user_preferences"
    }
    
    // MARK: - URLs
    
    /// روابط مفيدة
    struct URLs {
        static let privacyPolicy = "https://yourapp.com/privacy"
        static let termsOfService = "https://yourapp.com/terms"
        static let support = "https://yourapp.com/support"
        static let appStore = "https://apps.apple.com/app/idXXXXXXXXXX"
    }
    
    // MARK: - Feature Flags
    
    /// ميزات التطبيق
    struct Features {
        /// تفعيل ميزات AI
        static var isAIEnabled: Bool {
            return !geminiAPIKey.isEmpty && geminiAPIKey != "YOUR_GEMINI_API_KEY_HERE"
        }
        
        /// تفعيل الردود الذكية
        static var isSmartReplyEnabled: Bool {
            return isAIEnabled
        }
        
        /// تفعيل أدوات البرمجة
        static var isCodeToolsEnabled: Bool {
            return isAIEnabled
        }
        
        /// تفعيل الإملاء الصوتي
        static var isDictationEnabled: Bool {
            return true
        }
    }
    
    // MARK: - Limits
    
    /// حدود الاستخدام
    struct Limits {
        /// الحد الأقصى لطول النص للمعالجة
        static let maxTextLength = 5000
        
        /// الحد الأقصى لعدد الردود الذكية
        static let maxSmartReplies = 4
        
        /// مهلة طلبات API (بالثواني)
        static let apiTimeout: TimeInterval = 30
    }
}

// MARK: - Helper Extensions

extension AppConfig {
    
    /// حفظ مفتاح API
    static func saveGeminiAPIKey(_ key: String) {
        sharedDefaults?.set(key, forKey: Keys.geminiAPIKey)
    }
    
    /// حفظ اللغة المختارة
    static func saveSelectedLanguage(_ language: String) {
        sharedDefaults?.set(language, forKey: Keys.selectedLanguage)
    }
    
    /// الحصول على اللغة المختارة
    static func getSelectedLanguage() -> String {
        return sharedDefaults?.string(forKey: Keys.selectedLanguage) ?? "ar"
    }
    
    /// حفظ الثيم المختار
    static func saveSelectedTheme(_ theme: String) {
        sharedDefaults?.set(theme, forKey: Keys.selectedTheme)
    }
    
    /// الحصول على الثيم المختار
    static func getSelectedTheme() -> String {
        return sharedDefaults?.string(forKey: Keys.selectedTheme) ?? "default"
    }
}
