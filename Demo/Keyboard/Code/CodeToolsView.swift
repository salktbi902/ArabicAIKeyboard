//
//  CodeToolsView.swift
//  Arabic AI Keyboard
//
//  💻 واجهة أدوات البرمجة
//  تشمل: قوالب الكود، أدوات AI، لوحة الرموز
//

import SwiftUI
import KeyboardKit

// MARK: - قائمة أدوات البرمجة الرئيسية

struct CodeToolsMenu: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @StateObject private var codeService = CodeService.shared
    @State private var selectedTab: CodeToolsTab = .tools
    @State private var selectedLanguage: ProgrammingLanguage = .swift
    @State private var showLanguagePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // شريط اللغة
                languageBar
                
                // التبويبات
                tabBar
                
                // المحتوى
                tabContent
            }
            .navigationTitle("أدوات البرمجة")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("إغلاق") {
                        isPresented = false
                    }
                }
            }
        }
        .sheet(isPresented: $showLanguagePicker) {
            LanguagePickerSheet(
                selectedLanguage: $selectedLanguage,
                isPresented: $showLanguagePicker
            )
        }
    }
    
    // MARK: - شريط اللغة
    
    private var languageBar: some View {
        Button {
            showLanguagePicker = true
        } label: {
            HStack {
                Image(systemName: selectedLanguage.icon)
                Text(selectedLanguage.displayName)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - شريط التبويبات
    
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(CodeToolsTab.allCases) { tab in
                Button {
                    withAnimation {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.title3)
                        Text(tab.titleAr)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.secondary.opacity(0.05))
    }
    
    // MARK: - محتوى التبويب
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .tools:
            CodeAIToolsView(language: selectedLanguage)
        case .snippets:
            CodeSnippetsView(language: selectedLanguage)
        case .symbols:
            ProgrammerSymbolsView()
        case .generate:
            CodeGeneratorView(language: selectedLanguage)
        }
    }
}

// MARK: - تبويبات أدوات البرمجة

enum CodeToolsTab: String, CaseIterable, Identifiable {
    case tools = "tools"
    case snippets = "snippets"
    case symbols = "symbols"
    case generate = "generate"
    
    var id: String { rawValue }
    
    var titleAr: String {
        switch self {
        case .tools: return "أدوات AI"
        case .snippets: return "قوالب"
        case .symbols: return "رموز"
        case .generate: return "توليد"
        }
    }
    
    var icon: String {
        switch self {
        case .tools: return "wand.and.stars"
        case .snippets: return "doc.on.clipboard"
        case .symbols: return "curlybraces"
        case .generate: return "sparkles"
        }
    }
}

// MARK: - أدوات AI للكود

struct CodeAIToolsView: View {
    
    let language: ProgrammingLanguage
    @EnvironmentObject var keyboardContext: KeyboardContext
    @StateObject private var codeService = CodeService.shared
    
    @State private var inputCode = ""
    @State private var resultCode = ""
    @State private var selectedCommand: CodeCommand?
    @State private var targetLanguage: ProgrammingLanguage = .python
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // حقل إدخال الكود
                codeInputSection
                
                // أزرار الأوامر
                commandsGrid
                
                // النتيجة
                if !resultCode.isEmpty {
                    resultSection
                }
            }
            .padding()
        }
        .onAppear {
            loadCurrentCode()
        }
    }
    
    // MARK: - قسم إدخال الكود
    
    private var codeInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("الكود:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("مسح") {
                    inputCode = ""
                    resultCode = ""
                }
                .font(.caption)
            }
            
            TextEditor(text: $inputCode)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 100, maxHeight: 150)
                .padding(8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    // MARK: - شبكة الأوامر
    
    private var commandsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            ForEach(CodeCommand.allCases) { command in
                CommandButton(
                    command: command,
                    isLoading: codeService.isProcessing && selectedCommand == command
                ) {
                    executeCommand(command)
                }
            }
        }
    }
    
    // MARK: - قسم النتيجة
    
    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("النتيجة:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button("نسخ") {
                    UIPasteboard.general.string = resultCode
                }
                .font(.caption)
                Button("إدراج") {
                    insertResult()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            ScrollView {
                Text(resultCode)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 200)
            .padding(8)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // MARK: - الإجراءات
    
    private func loadCurrentCode() {
        let proxy = keyboardContext.textDocumentProxy
        if let before = proxy.documentContextBeforeInput {
            inputCode = before
        }
    }
    
    private func executeCommand(_ command: CodeCommand) {
        guard !inputCode.isEmpty else { return }
        
        selectedCommand = command
        
        Task {
            var result: String?
            
            switch command {
            case .explain:
                result = await codeService.explainCode(inputCode, language: language)
            case .fix:
                result = await codeService.fixCode(inputCode, language: language)
            case .format:
                result = await codeService.formatCode(inputCode, language: language)
            case .convert:
                result = await codeService.convertCode(inputCode, from: language, to: targetLanguage)
            case .generate:
                result = await codeService.generateCode(description: inputCode, language: language)
            case .complete:
                result = await codeService.completeCode(inputCode, language: language)
            case .optimize:
                result = await codeService.optimizeCode(inputCode, language: language)
            case .comment:
                result = await codeService.addComments(inputCode, language: language, inArabic: true)
            case .test:
                result = await codeService.generateTests(inputCode, language: language)
            case .document:
                result = await codeService.generateDocumentation(inputCode, language: language)
            }
            
            await MainActor.run {
                if let result = result {
                    resultCode = result
                }
                selectedCommand = nil
            }
        }
    }
    
    private func insertResult() {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(resultCode)
    }
}

// MARK: - زر الأمر

struct CommandButton: View {
    
    let command: CodeCommand
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: command.icon)
                        .font(.title3)
                }
                Text(command.titleAr)
                    .font(.caption)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(commandColor.opacity(0.15))
            .foregroundColor(commandColor)
            .cornerRadius(10)
        }
        .disabled(isLoading)
        .buttonStyle(.plain)
    }
    
    private var commandColor: Color {
        switch command.color {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "cyan": return .cyan
        case "yellow": return .yellow
        case "gray": return .gray
        case "indigo": return .indigo
        case "teal": return .teal
        default: return .blue
        }
    }
}

// MARK: - عرض قوالب الكود

struct CodeSnippetsView: View {
    
    let language: ProgrammingLanguage
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    @State private var searchText = ""
    @State private var selectedCategory: SnippetCategory?
    
    private let snippetsLibrary = CodeSnippetsLibrary.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // شريط البحث
            searchBar
            
            // فئات القوالب
            categoriesBar
            
            // قائمة القوالب
            snippetsList
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("بحث في القوالب...", text: $searchText)
        }
        .padding(10)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var categoriesBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    title: "الكل",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(SnippetCategory.allCases) { category in
                    CategoryChip(
                        title: category.titleAr,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    private var snippetsList: some View {
        let snippets = filteredSnippets
        
        return List {
            if snippets.isEmpty {
                Text("لا توجد قوالب")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(snippets) { snippet in
                    SnippetRow(snippet: snippet) {
                        insertSnippet(snippet)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var filteredSnippets: [CodeSnippet] {
        var snippets = snippetsLibrary.getSnippets(for: language)
        
        if let category = selectedCategory {
            snippets = snippets.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            snippets = snippets.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.titleAr.contains(searchText) ||
                $0.description.contains(searchText)
            }
        }
        
        return snippets
    }
    
    private func insertSnippet(_ snippet: CodeSnippet) {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(snippet.code)
    }
}

// MARK: - شريحة الفئة

struct CategoryChip: View {
    
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.secondary.opacity(0.15))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - صف القالب

struct SnippetRow: View {
    
    let snippet: CodeSnippet
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(snippet.titleAr)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(snippet.category.titleAr)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Text(snippet.code)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(snippet.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - عرض الرموز البرمجية

struct ProgrammerSymbolsView: View {
    
    @EnvironmentObject var keyboardContext: KeyboardContext
    
    let symbolGroups: [(String, [String])] = [
        ("أقواس", ["{", "}", "[", "]", "(", ")", "<", ">"]),
        ("عمليات", ["+", "-", "*", "/", "%", "=", "!", "&", "|", "^"]),
        ("مقارنة", ["==", "!=", "<=", ">=", "&&", "||", "??"]),
        ("علامات", [":", ";", ",", ".", "\"", "'", "`", "@", "#", "$"]),
        ("أسهم", ["->", "=>", "<-", "::", "..."]),
        ("تعليقات", ["//", "/*", "*/", "<!--", "-->", "#"]),
        ("خاصة", ["\\n", "\\t", "\\r", "\\\\", "_", "~"])
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(symbolGroups, id: \.0) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.0)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 50))
                        ], spacing: 8) {
                            ForEach(group.1, id: \.self) { symbol in
                                SymbolButton(symbol: symbol) {
                                    insertSymbol(symbol)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private func insertSymbol(_ symbol: String) {
        let proxy = keyboardContext.textDocumentProxy
        
        // تحويل الرموز الخاصة
        var actualSymbol = symbol
        switch symbol {
        case "\\n": actualSymbol = "\n"
        case "\\t": actualSymbol = "\t"
        case "\\r": actualSymbol = "\r"
        case "\\\\": actualSymbol = "\\"
        default: break
        }
        
        proxy.insertText(actualSymbol)
    }
}

// MARK: - زر الرمز

struct SymbolButton: View {
    
    let symbol: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(symbol)
                .font(.system(.body, design: .monospaced))
                .frame(minWidth: 44, minHeight: 44)
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - عرض توليد الكود

struct CodeGeneratorView: View {
    
    let language: ProgrammingLanguage
    @EnvironmentObject var keyboardContext: KeyboardContext
    @StateObject private var codeService = CodeService.shared
    
    @State private var description = ""
    @State private var generatedCode = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // وصف ما تريد
                VStack(alignment: .leading, spacing: 8) {
                    Text("صف ما تريد برمجته:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 80, maxHeight: 120)
                        .padding(8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // أمثلة سريعة
                VStack(alignment: .leading, spacing: 8) {
                    Text("أمثلة سريعة:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            QuickPromptChip(text: "دالة لحساب المجموع") {
                                description = "دالة لحساب مجموع الأرقام في مصفوفة"
                            }
                            QuickPromptChip(text: "طلب API") {
                                description = "دالة لإرسال طلب GET لـ API وإرجاع البيانات"
                            }
                            QuickPromptChip(text: "ترتيب مصفوفة") {
                                description = "دالة لترتيب مصفوفة أرقام تصاعدياً"
                            }
                            QuickPromptChip(text: "قراءة ملف") {
                                description = "دالة لقراءة محتوى ملف نصي"
                            }
                        }
                    }
                }
                
                // زر التوليد
                Button {
                    generateCode()
                } label: {
                    HStack {
                        if codeService.isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "sparkles")
                        }
                        Text("توليد كود \(language.displayName)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(description.isEmpty || codeService.isProcessing)
                
                // الكود المولّد
                if !generatedCode.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("الكود المولّد:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button("نسخ") {
                                UIPasteboard.general.string = generatedCode
                            }
                            .font(.caption)
                            Button("إدراج") {
                                insertCode()
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        
                        ScrollView {
                            Text(generatedCode)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: 250)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
    
    private func generateCode() {
        Task {
            if let result = await codeService.generateCode(description: description, language: language) {
                await MainActor.run {
                    generatedCode = result
                }
            }
        }
    }
    
    private func insertCode() {
        let proxy = keyboardContext.textDocumentProxy
        proxy.insertText(generatedCode)
    }
}

// MARK: - شريحة الاقتراح السريع

struct QuickPromptChip: View {
    
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.15))
                .foregroundColor(.orange)
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - اختيار اللغة

struct LanguagePickerSheet: View {
    
    @Binding var selectedLanguage: ProgrammingLanguage
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ProgrammingLanguage.allCases) { language in
                    Button {
                        selectedLanguage = language
                        isPresented = false
                    } label: {
                        HStack {
                            Image(systemName: language.icon)
                                .frame(width: 30)
                            Text(language.displayName)
                            Spacer()
                            if language == selectedLanguage {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("اختر لغة البرمجة")
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

#Preview("Code Tools Menu") {
    CodeToolsMenu(isPresented: .constant(true))
}
