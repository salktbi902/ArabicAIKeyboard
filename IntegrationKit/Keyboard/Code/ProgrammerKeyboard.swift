//
//  ProgrammerKeyboard.swift
//  Arabic AI Keyboard
//
//  ⌨️ لوحة المفاتيح البرمجية
//  أزرار سريعة للرموز والأقواس والعمليات البرمجية
//

import SwiftUI
import KeyboardKit

// MARK: - لوحة المفاتيح البرمجية

struct ProgrammerKeyboardView: View {
    
    @EnvironmentObject var keyboardContext: KeyboardContext
    @State private var currentPage: ProgrammerKeyboardPage = .brackets
    
    var body: some View {
        VStack(spacing: 0) {
            // شريط التبويبات
            pageTabBar
            
            // محتوى الصفحة
            pageContent
        }
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - شريط التبويبات
    
    private var pageTabBar: some View {
        HStack(spacing: 0) {
            ForEach(ProgrammerKeyboardPage.allCases) { page in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        currentPage = page
                    }
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: page.icon)
                            .font(.caption)
                        Text(page.titleAr)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(currentPage == page ? Color.blue.opacity(0.15) : Color.clear)
                    .foregroundColor(currentPage == page ? .blue : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.secondary.opacity(0.1))
    }
    
    // MARK: - محتوى الصفحة
    
    @ViewBuilder
    private var pageContent: some View {
        switch currentPage {
        case .brackets:
            bracketsKeyboard
        case .operators:
            operatorsKeyboard
        case .comparison:
            comparisonKeyboard
        case .punctuation:
            punctuationKeyboard
        case .arrows:
            arrowsKeyboard
        case .numbers:
            numbersKeyboard
        }
    }
    
    // MARK: - لوحة الأقواس
    
    private var bracketsKeyboard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "(", action: insertSymbol)
                ProgrammerKey(symbol: ")", action: insertSymbol)
                ProgrammerKey(symbol: "{", action: insertSymbol)
                ProgrammerKey(symbol: "}", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "[", action: insertSymbol)
                ProgrammerKey(symbol: "]", action: insertSymbol)
                ProgrammerKey(symbol: "<", action: insertSymbol)
                ProgrammerKey(symbol: ">", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "()", label: "( )", action: insertPair)
                ProgrammerKey(symbol: "{}", label: "{ }", action: insertPair)
                ProgrammerKey(symbol: "[]", label: "[ ]", action: insertPair)
                ProgrammerKey(symbol: "<>", label: "< >", action: insertPair)
            }
        }
        .padding(8)
    }
    
    // MARK: - لوحة العمليات
    
    private var operatorsKeyboard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "+", action: insertSymbol)
                ProgrammerKey(symbol: "-", action: insertSymbol)
                ProgrammerKey(symbol: "*", action: insertSymbol)
                ProgrammerKey(symbol: "/", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "%", action: insertSymbol)
                ProgrammerKey(symbol: "=", action: insertSymbol)
                ProgrammerKey(symbol: "!", action: insertSymbol)
                ProgrammerKey(symbol: "^", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "&", action: insertSymbol)
                ProgrammerKey(symbol: "|", action: insertSymbol)
                ProgrammerKey(symbol: "~", action: insertSymbol)
                ProgrammerKey(symbol: "?", action: insertSymbol)
            }
        }
        .padding(8)
    }
    
    // MARK: - لوحة المقارنة
    
    private var comparisonKeyboard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "==", action: insertSymbol)
                ProgrammerKey(symbol: "!=", action: insertSymbol)
                ProgrammerKey(symbol: "===", action: insertSymbol)
                ProgrammerKey(symbol: "!==", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "<=", action: insertSymbol)
                ProgrammerKey(symbol: ">=", action: insertSymbol)
                ProgrammerKey(symbol: "&&", action: insertSymbol)
                ProgrammerKey(symbol: "||", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "??", action: insertSymbol)
                ProgrammerKey(symbol: "?.", action: insertSymbol)
                ProgrammerKey(symbol: "+=", action: insertSymbol)
                ProgrammerKey(symbol: "-=", action: insertSymbol)
            }
        }
        .padding(8)
    }
    
    // MARK: - لوحة علامات الترقيم
    
    private var punctuationKeyboard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ProgrammerKey(symbol: ";", action: insertSymbol)
                ProgrammerKey(symbol: ":", action: insertSymbol)
                ProgrammerKey(symbol: ",", action: insertSymbol)
                ProgrammerKey(symbol: ".", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "\"", action: insertSymbol)
                ProgrammerKey(symbol: "'", action: insertSymbol)
                ProgrammerKey(symbol: "`", action: insertSymbol)
                ProgrammerKey(symbol: "_", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "@", action: insertSymbol)
                ProgrammerKey(symbol: "#", action: insertSymbol)
                ProgrammerKey(symbol: "$", action: insertSymbol)
                ProgrammerKey(symbol: "\\", action: insertSymbol)
            }
        }
        .padding(8)
    }
    
    // MARK: - لوحة الأسهم
    
    private var arrowsKeyboard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "->", action: insertSymbol)
                ProgrammerKey(symbol: "=>", action: insertSymbol)
                ProgrammerKey(symbol: "<-", action: insertSymbol)
                ProgrammerKey(symbol: "<>", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "::", action: insertSymbol)
                ProgrammerKey(symbol: "...", action: insertSymbol)
                ProgrammerKey(symbol: "..<", action: insertSymbol)
                ProgrammerKey(symbol: "//", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "/*", action: insertSymbol)
                ProgrammerKey(symbol: "*/", action: insertSymbol)
                ProgrammerKey(symbol: "///", action: insertSymbol)
                ProgrammerKey(symbol: "/**", action: insertSymbol)
            }
        }
        .padding(8)
    }
    
    // MARK: - لوحة الأرقام
    
    private var numbersKeyboard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "1", action: insertSymbol)
                ProgrammerKey(symbol: "2", action: insertSymbol)
                ProgrammerKey(symbol: "3", action: insertSymbol)
                ProgrammerKey(symbol: "0x", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "4", action: insertSymbol)
                ProgrammerKey(symbol: "5", action: insertSymbol)
                ProgrammerKey(symbol: "6", action: insertSymbol)
                ProgrammerKey(symbol: "0b", action: insertSymbol)
            }
            HStack(spacing: 8) {
                ProgrammerKey(symbol: "7", action: insertSymbol)
                ProgrammerKey(symbol: "8", action: insertSymbol)
                ProgrammerKey(symbol: "9", action: insertSymbol)
                ProgrammerKey(symbol: "0", action: insertSymbol)
            }
        }
        .padding(8)
    }
    
    // MARK: - الإجراءات
    
    private func insertSymbol(_ symbol: String) {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(symbol)
    }
    
    private func insertPair(_ pair: String) {
        let proxy = keyboardContext.textDocumentProxy
        
        // إدراج الزوج مع وضع المؤشر في المنتصف
        switch pair {
        case "()":
            proxy.insertText("()")
            proxy.adjustTextPosition(byCharacterOffset: -1)
        case "{}":
            proxy.insertText("{}")
            proxy.adjustTextPosition(byCharacterOffset: -1)
        case "[]":
            proxy.insertText("[]")
            proxy.adjustTextPosition(byCharacterOffset: -1)
        case "<>":
            proxy.insertText("<>")
            proxy.adjustTextPosition(byCharacterOffset: -1)
        default:
            proxy.insertText(pair)
        }
    }
}

// MARK: - صفحات لوحة المفاتيح

enum ProgrammerKeyboardPage: String, CaseIterable, Identifiable {
    case brackets = "brackets"
    case operators = "operators"
    case comparison = "comparison"
    case punctuation = "punctuation"
    case arrows = "arrows"
    case numbers = "numbers"
    
    var id: String { rawValue }
    
    var titleAr: String {
        switch self {
        case .brackets: return "أقواس"
        case .operators: return "عمليات"
        case .comparison: return "مقارنة"
        case .punctuation: return "ترقيم"
        case .arrows: return "أسهم"
        case .numbers: return "أرقام"
        }
    }
    
    var icon: String {
        switch self {
        case .brackets: return "curlybraces"
        case .operators: return "plus.forwardslash.minus"
        case .comparison: return "equal"
        case .punctuation: return "textformat"
        case .arrows: return "arrow.right"
        case .numbers: return "number"
        }
    }
}

// MARK: - زر لوحة المفاتيح البرمجية

struct ProgrammerKey: View {
    
    let symbol: String
    var label: String? = nil
    let action: (String) -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            action(symbol)
            
            // تأثير الضغط
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        } label: {
            Text(label ?? symbol)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isPressed ? Color.blue.opacity(0.3) : Color.secondary.opacity(0.15))
                .foregroundColor(.primary)
                .cornerRadius(8)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - شريط الأدوات البرمجي السريع

struct ProgrammerToolbar: View {
    
    @EnvironmentObject var keyboardContext: KeyboardContext
    @State private var showFullKeyboard = false
    @State private var showCodeTools = false
    
    let quickSymbols = ["{", "}", "(", ")", "[", "]", ";", ":", "=", "->"]
    
    var body: some View {
        HStack(spacing: 0) {
            // زر فتح لوحة المفاتيح الكاملة
            Button {
                showFullKeyboard = true
            } label: {
                Image(systemName: "keyboard")
                    .font(.caption)
                    .frame(width: 36, height: 36)
                    .background(Color.secondary.opacity(0.15))
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 4)
            
            // الرموز السريعة
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(quickSymbols, id: \.self) { symbol in
                        QuickSymbolButton(symbol: symbol) {
                            insertSymbol(symbol)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            
            // زر أدوات الكود
            Button {
                showCodeTools = true
            } label: {
                Image(systemName: "wand.and.stars")
                    .font(.caption)
                    .frame(width: 36, height: 36)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(6)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 4)
        }
        .padding(.vertical, 6)
        .background(Color.secondary.opacity(0.05))
        .sheet(isPresented: $showFullKeyboard) {
            ProgrammerKeyboardSheet(isPresented: $showFullKeyboard)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showCodeTools) {
            CodeToolsMenu(isPresented: $showCodeTools)
                .presentationDetents([.medium, .large])
        }
    }
    
    private func insertSymbol(_ symbol: String) {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(symbol)
    }
}

// MARK: - زر الرمز السريع

struct QuickSymbolButton: View {
    
    let symbol: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(symbol)
                .font(.system(.subheadline, design: .monospaced))
                .fontWeight(.medium)
                .frame(width: 32, height: 32)
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sheet لوحة المفاتيح البرمجية

struct ProgrammerKeyboardSheet: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ProgrammerKeyboardView()
                .navigationTitle("لوحة المفاتيح البرمجية")
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

// MARK: - Preview

#Preview("Programmer Keyboard") {
    ProgrammerKeyboardView()
        .frame(height: 200)
}

#Preview("Programmer Toolbar") {
    ProgrammerToolbar()
}
