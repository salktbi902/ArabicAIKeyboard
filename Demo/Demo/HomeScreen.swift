//
//  HomeScreen.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-11.
//  Copyright © 2021-2025 Daniel Saidi. All rights reserved.
//
//  Modified for Arabic AI Keyboard Enhancement
//

import KeyboardKit
import SwiftUI

/// This is the main demo app screen.
///
/// This view uses a KeyboardKit Pro `HomeScreen` to present
/// keyboard status and settings links with some adjustments.
///
/// See ``DemoApp`` for important, demo-specific information
/// on why the in-app keyboard settings aren't synced to the
/// keyboards by default, and how you can enable this.
struct HomeScreen: View {

    let app = KeyboardApp.keyboardKitDemo

    @State var text = ""
    @State var textEmail = ""
    @State var textMultiline = ""
    @State var textNumberPad = ""
    @State var textURL = ""
    @State var textWebSearch = ""

    @Environment(\.openURL) var openURL

    @EnvironmentObject var dictationContext: DictationContext
    @EnvironmentObject var keyboardContext: KeyboardContext

    var body: some View {
        NavigationView {
            KeyboardApp.HomeScreen(
                app: app,
                appIcon: Image(.icon),
                header: {
                    // قسم الترحيب بالعربية
                    VStack(spacing: 12) {
                        Text("🤖 لوحة المفاتيح العربية الذكية")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Text("مدعومة بالذكاء الاصطناعي من Google Gemini")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .listRowBackground(Color.blue.opacity(0.1))
                    .padding(.vertical, 8)
                },
                footer: {
                    // قسم ميزات AI
                    Section("🤖 ميزات الذكاء الاصطناعي") {
                        aiFeatureRow(icon: "eye", title: "تدقيق لغوي", description: "تصحيح الأخطاء الإملائية والنحوية", color: .blue)
                        aiFeatureRow(icon: "globe", title: "ترجمة فورية", description: "ترجمة بين العربية والإنجليزية", color: .green)
                        aiFeatureRow(icon: "textformat", title: "تشكيل النص", description: "إضافة الحركات للنص العربي", color: .purple)
                        aiFeatureRow(icon: "wand.and.stars", title: "تحسين الأسلوب", description: "تحسين جودة الكتابة", color: .orange)
                        aiFeatureRow(icon: "doc.text", title: "تلخيص", description: "تلخيص النصوص الطويلة", color: .indigo)
                        aiFeatureRow(icon: "arrow.up.left.and.arrow.down.right", title: "توسيع", description: "إضافة تفاصيل للنص", color: .teal)
                        aiFeatureRow(icon: "briefcase", title: "صياغة رسمية", description: "تحويل لأسلوب رسمي", color: .gray)
                        aiFeatureRow(icon: "face.smiling", title: "صياغة عامية", description: "تحويل لأسلوب ودي", color: .pink)
                        aiFeatureRow(icon: "arrowshape.turn.up.left", title: "رد ذكي", description: "اقتراح ردود مناسبة", color: .cyan)
                        aiFeatureRow(icon: "text.badge.plus", title: "إكمال تلقائي", description: "إكمال الجمل بذكاء", color: .mint)
                    }
                    
                    // قسم حقول الاختبار
                    Section("جرّب لوحة المفاتيح") {
                        TextField("اكتب هنا بالعربية...", text: $text)
                            .keyboardType(.default)
                            .environment(\.layoutDirection, .rightToLeft)
                        TextField("TextField.Email", text: $textEmail)
                            .keyboardType(.emailAddress)
                        TextField("TextField.NumberPad", text: $textNumberPad)
                            .keyboardType(.numberPad)
                        TextField("TextField.URL", text: $textURL)
                            .keyboardType(.URL)
                        TextField("TextField.WebSearch", text: $textWebSearch)
                            .keyboardType(.webSearch)
                        TextField("نص متعدد الأسطر...", text: $textMultiline, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .keyboardType(.default)
                            .environment(\.layoutDirection, .rightToLeft)
                    }
                    
                    // تعليمات الاستخدام
                    Section("💡 كيفية الاستخدام") {
                        VStack(alignment: .leading, spacing: 8) {
                            instructionRow(number: "1", text: "اكتب النص المراد معالجته")
                            instructionRow(number: "2", text: "اضغط على أحد أزرار AI في شريط الأدوات")
                            instructionRow(number: "3", text: "انتظر المعالجة (يظهر مؤشر دوران)")
                            instructionRow(number: "4", text: "سيتم استبدال النص بالنتيجة تلقائياً")
                        }
                        .padding(.vertical, 4)
                    }
                }
            )
            .navigationTitle("Arabic AI Keyboard")
        }
        .keyboardAppHomeScreenStyle(.init(
            appIconSize: 120,
            appIconCornerRadius: 27
        ))
        .navigationViewStyle(.stack)
    }
}

// MARK: - Helper Views

extension HomeScreen {
    
    func dictationScreen() -> some View {
        Dictation.Screen(
            titleView: { EmptyView() },
            visualizer: { Dictation.BarVisualizer(isAnimating: $0) },
            doneButton: { action in
                Button("Button.Done", action: action)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
    
    /// صف ميزة AI
    func aiFeatureRow(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    /// صف تعليمات
    func instructionRow(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    HomeScreen()
}
