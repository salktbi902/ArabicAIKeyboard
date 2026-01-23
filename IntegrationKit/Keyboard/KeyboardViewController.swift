//
//  KeyboardViewController.swift
//  Arabic AI Keyboard
//
//  🎹 وحدة التحكم الرئيسية للكيبورد
//  جاهز للدمج في أي تطبيق iOS
//

import UIKit
import SwiftUI
import KeyboardKit

/// وحدة التحكم الرئيسية للكيبورد العربي الذكي
class KeyboardViewController: KeyboardInputViewController {
    
    // MARK: - Properties
    
    /// خدمة الذكاء الاصطناعي
    private let geminiService = GeminiService.shared
    
    /// خدمة الردود الذكية
    private let smartReplyService = SmartReplyService.shared
    
    /// خدمة البرمجة
    private let codeService = CodeService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // إعداد الكيبورد
        setupKeyboard()
        
        // إعداد الخدمات
        setupServices()
    }
    
    override func viewWillSetupKeyboardView() {
        super.viewWillSetupKeyboardView()
        
        // إعداد واجهة الكيبورد المخصصة
        setupKeyboardView { controller in
            ArabicKeyboardView(
                state: controller.state,
                services: controller.services
            )
        }
    }
    
    // MARK: - Setup
    
    /// إعداد الكيبورد
    private func setupKeyboard() {
        // إعداد اللغات
        setupLocales()
        
        // إعداد السلوك
        setupBehavior()
        
        // إعداد المظهر
        setupAppearance()
    }
    
    /// إعداد اللغات
    private func setupLocales() {
        // اللغات المدعومة
        let locales: [Locale] = [
            Locale(identifier: "ar"),      // العربية
            Locale(identifier: "en"),      // الإنجليزية
            Locale(identifier: "ar_SA"),   // العربية السعودية
            Locale(identifier: "ar_AE"),   // العربية الإماراتية
        ]
        
        state.keyboardContext.locales = locales
        state.keyboardContext.setLocale(.init(identifier: "ar"))
    }
    
    /// إعداد السلوك
    private func setupBehavior() {
        // تفعيل الإكمال التلقائي
        state.autocompleteContext.isEnabled = true
        
        // إعدادات الكيبورد
        state.keyboardContext.settings.isAutocapitalizationEnabled = true
    }
    
    /// إعداد المظهر
    private func setupAppearance() {
        // يمكنك تخصيص الثيم هنا
        // state.themeContext.theme = .standard
    }
    
    /// إعداد الخدمات
    private func setupServices() {
        // إعداد مفتاح API لـ Gemini
        // يجب تعيين المفتاح من الإعدادات أو من التطبيق الرئيسي
        if let apiKey = UserDefaults(suiteName: AppConfig.appGroupIdentifier)?.string(forKey: "gemini_api_key") {
            geminiService.setAPIKey(apiKey)
        }
    }
}

// MARK: - Arabic Keyboard View

/// واجهة الكيبورد العربي الذكي
struct ArabicKeyboardView: View {
    
    let state: Keyboard.State
    let services: Keyboard.Services
    
    @State private var showAIMenu = false
    @State private var showCodeTools = false
    @State private var showSmartReply = false
    
    var body: some View {
        VStack(spacing: 0) {
            // شريط الأدوات العلوي
            topToolbar
            
            // الكيبورد الأساسي
            KeyboardView(
                state: state,
                services: services,
                buttonContent: { $0.view },
                buttonView: { $0.view },
                collapsedView: { $0.view },
                emojiKeyboard: { $0.view },
                toolbar: { _ in EmptyView() }
            )
        }
        .sheet(isPresented: $showAIMenu) {
            AIMenuSheet(isPresented: $showAIMenu)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showCodeTools) {
            CodeToolsMenu(isPresented: $showCodeTools)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showSmartReply) {
            SmartReplySheet(isPresented: $showSmartReply)
                .presentationDetents([.medium])
        }
    }
    
    // MARK: - Top Toolbar
    
    private var topToolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // زر الذكاء الاصطناعي
                ToolbarButton(
                    icon: "brain",
                    title: "AI",
                    color: .purple
                ) {
                    showAIMenu = true
                }
                
                // زر الردود الذكية
                ToolbarButton(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "ردود",
                    color: .cyan
                ) {
                    showSmartReply = true
                }
                
                // زر أدوات البرمجة
                ToolbarButton(
                    icon: "chevron.left.forwardslash.chevron.right",
                    title: "كود",
                    color: .indigo
                ) {
                    showCodeTools = true
                }
                
                Divider()
                    .frame(height: 24)
                
                // أزرار الأوامر السريعة
                QuickCommandButton(command: .proofread)
                QuickCommandButton(command: .translate)
                QuickCommandButton(command: .diacritics)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
}

// MARK: - Toolbar Button

struct ToolbarButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.15))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Command Button

struct QuickCommandButton: View {
    let command: AICommand
    
    @StateObject private var geminiService = GeminiService.shared
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @State private var isProcessing = false
    
    var body: some View {
        Button {
            executeCommand()
        } label: {
            HStack(spacing: 4) {
                if isProcessing {
                    ProgressView()
                        .scaleEffect(0.6)
                } else {
                    Image(systemName: command.icon)
                        .font(.caption)
                }
                Text(command.titleAr)
                    .font(.caption2)
            }
            .foregroundColor(commandColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(commandColor.opacity(0.15))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        .disabled(isProcessing)
    }
    
    private var commandColor: Color {
        switch command {
        case .proofread: return .blue
        case .translate: return .green
        case .diacritics: return .purple
        case .improve: return .orange
        default: return .gray
        }
    }
    
    private func executeCommand() {
        let proxy = keyboardContext.textDocumentProxy
        
        guard let text = proxy.documentContextBeforeInput, !text.isEmpty else { return }
        
        isProcessing = true
        
        Task {
            if let result = await geminiService.process(text, command: command) {
                await MainActor.run {
                    // حذف النص القديم
                    for _ in 0..<text.count {
                        proxy.deleteBackward()
                    }
                    // إدراج النتيجة
                    proxy.insertText(result)
                }
            }
            
            await MainActor.run {
                isProcessing = false
            }
        }
    }
}

// MARK: - AI Menu Sheet

struct AIMenuSheet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            AIMenu(
                actionHandler: .preview,
                isPresented: $isPresented
            )
            .navigationTitle("الذكاء الاصطناعي")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("إغلاق") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
