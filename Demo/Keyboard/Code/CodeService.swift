//
//  CodeService.swift
//  Arabic AI Keyboard
//
//  💻 خدمة البرمجة - أدوات الكود والتطوير
//  تشمل: شرح، تصحيح، تنسيق، تحويل، توليد الكود
//

import Foundation

// MARK: - لغات البرمجة المدعومة

enum ProgrammingLanguage: String, CaseIterable, Identifiable {
    case swift = "swift"
    case python = "python"
    case javascript = "javascript"
    case typescript = "typescript"
    case java = "java"
    case kotlin = "kotlin"
    case csharp = "csharp"
    case cpp = "cpp"
    case go = "go"
    case rust = "rust"
    case php = "php"
    case ruby = "ruby"
    case sql = "sql"
    case html = "html"
    case css = "css"
    case dart = "dart"
    case shell = "shell"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .swift: return "Swift"
        case .python: return "Python"
        case .javascript: return "JavaScript"
        case .typescript: return "TypeScript"
        case .java: return "Java"
        case .kotlin: return "Kotlin"
        case .csharp: return "C#"
        case .cpp: return "C++"
        case .go: return "Go"
        case .rust: return "Rust"
        case .php: return "PHP"
        case .ruby: return "Ruby"
        case .sql: return "SQL"
        case .html: return "HTML"
        case .css: return "CSS"
        case .dart: return "Dart"
        case .shell: return "Shell/Bash"
        }
    }
    
    var icon: String {
        switch self {
        case .swift: return "swift"
        case .python: return "chevron.left.forwardslash.chevron.right"
        case .javascript, .typescript: return "curlybraces"
        case .java, .kotlin: return "cup.and.saucer"
        case .csharp: return "number"
        case .cpp: return "plus.forwardslash.minus"
        case .go: return "hare"
        case .rust: return "gearshape.2"
        case .php: return "server.rack"
        case .ruby: return "diamond"
        case .sql: return "cylinder"
        case .html: return "doc.text"
        case .css: return "paintbrush"
        case .dart: return "arrow.triangle.branch"
        case .shell: return "terminal"
        }
    }
    
    var color: String {
        switch self {
        case .swift: return "orange"
        case .python: return "blue"
        case .javascript: return "yellow"
        case .typescript: return "blue"
        case .java: return "red"
        case .kotlin: return "purple"
        case .csharp: return "green"
        case .cpp: return "blue"
        case .go: return "cyan"
        case .rust: return "orange"
        case .php: return "indigo"
        case .ruby: return "red"
        case .sql: return "gray"
        case .html: return "orange"
        case .css: return "blue"
        case .dart: return "cyan"
        case .shell: return "green"
        }
    }
}

// MARK: - أوامر الكود

enum CodeCommand: String, CaseIterable, Identifiable {
    case explain = "explain"           // شرح الكود
    case fix = "fix"                   // تصحيح الأخطاء
    case format = "format"             // تنسيق الكود
    case convert = "convert"           // تحويل لغة أخرى
    case generate = "generate"         // توليد كود من وصف
    case complete = "complete"         // إكمال الكود
    case optimize = "optimize"         // تحسين الأداء
    case comment = "comment"           // إضافة تعليقات
    case test = "test"                 // توليد اختبارات
    case document = "document"         // توليد توثيق
    
    var id: String { rawValue }
    
    var titleAr: String {
        switch self {
        case .explain: return "شرح الكود"
        case .fix: return "تصحيح الأخطاء"
        case .format: return "تنسيق"
        case .convert: return "تحويل اللغة"
        case .generate: return "توليد كود"
        case .complete: return "إكمال"
        case .optimize: return "تحسين"
        case .comment: return "تعليقات"
        case .test: return "اختبارات"
        case .document: return "توثيق"
        }
    }
    
    var icon: String {
        switch self {
        case .explain: return "questionmark.circle"
        case .fix: return "wrench.and.screwdriver"
        case .format: return "text.alignleft"
        case .convert: return "arrow.triangle.2.circlepath"
        case .generate: return "wand.and.stars"
        case .complete: return "text.badge.plus"
        case .optimize: return "bolt"
        case .comment: return "text.bubble"
        case .test: return "checkmark.shield"
        case .document: return "doc.text"
        }
    }
    
    var color: String {
        switch self {
        case .explain: return "blue"
        case .fix: return "red"
        case .format: return "green"
        case .convert: return "purple"
        case .generate: return "orange"
        case .complete: return "cyan"
        case .optimize: return "yellow"
        case .comment: return "gray"
        case .test: return "indigo"
        case .document: return "teal"
        }
    }
}

// MARK: - خدمة الكود

class CodeService: ObservableObject {
    
    static let shared = CodeService()
    
    private let apiKey = "AIzaSyBe-R4ISfWhh2og7YyPVDpDSxzK4357dc8"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    @Published var isProcessing = false
    @Published var lastError: String?
    @Published var lastResult: String?
    
    private init() {}
    
    // MARK: - شرح الكود بالعربي
    
    func explainCode(_ code: String, language: ProgrammingLanguage? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        let prompt = """
        أنت مدرس برمجة محترف. اشرح الكود التالي بالعربية بشكل مبسط وواضح.
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        قدم شرحاً يتضمن:
        1. ماذا يفعل هذا الكود؟
        2. شرح كل جزء مهم
        3. أي ملاحظات أو تحسينات مقترحة
        
        استخدم لغة عربية بسيطة ومفهومة.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - تصحيح الأخطاء
    
    func fixCode(_ code: String, language: ProgrammingLanguage? = nil, errorMessage: String? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        let errorInfo = errorMessage.map { "رسالة الخطأ: \($0)\n" } ?? ""
        
        let prompt = """
        أنت مبرمج خبير. صحح الأخطاء في الكود التالي.
        
        اللغة: \(langName)
        \(errorInfo)
        
        الكود:
        ```
        \(code)
        ```
        
        أعد الكود المصحح فقط بدون شرح.
        إذا لم تجد أخطاء، أعد الكود كما هو.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - تنسيق الكود
    
    func formatCode(_ code: String, language: ProgrammingLanguage? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        
        let prompt = """
        نسّق الكود التالي بشكل احترافي مع:
        - مسافات بادئة صحيحة
        - أسطر فارغة مناسبة
        - ترتيب منطقي
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        أعد الكود المنسق فقط.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - تحويل الكود لغة أخرى
    
    func convertCode(_ code: String, from sourceLanguage: ProgrammingLanguage?, to targetLanguage: ProgrammingLanguage) async -> String? {
        let sourceName = sourceLanguage?.displayName ?? "المكتشفة تلقائياً"
        
        let prompt = """
        حوّل الكود التالي من \(sourceName) إلى \(targetLanguage.displayName).
        
        الكود الأصلي:
        ```
        \(code)
        ```
        
        أعد الكود المحوّل فقط بصيغة \(targetLanguage.displayName).
        حافظ على نفس الوظيفة والمنطق.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - توليد كود من وصف
    
    func generateCode(description: String, language: ProgrammingLanguage) async -> String? {
        let prompt = """
        اكتب كود \(language.displayName) يقوم بالتالي:
        
        \(description)
        
        المتطلبات:
        - كود نظيف ومقروء
        - تعليقات توضيحية بالعربية
        - معالجة الأخطاء المحتملة
        
        أعد الكود فقط.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - إكمال الكود
    
    func completeCode(_ code: String, language: ProgrammingLanguage? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        
        let prompt = """
        أكمل الكود التالي بطريقة منطقية ومناسبة.
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        أعد الكود الكامل (الأصلي + الإكمال).
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - تحسين الأداء
    
    func optimizeCode(_ code: String, language: ProgrammingLanguage? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        
        let prompt = """
        حسّن أداء الكود التالي مع الحفاظ على نفس الوظيفة.
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        أعد الكود المحسّن فقط.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - إضافة تعليقات
    
    func addComments(_ code: String, language: ProgrammingLanguage? = nil, inArabic: Bool = true) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        let commentLang = inArabic ? "العربية" : "الإنجليزية"
        
        let prompt = """
        أضف تعليقات توضيحية للكود التالي باللغة \(commentLang).
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        أعد الكود مع التعليقات.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - توليد اختبارات
    
    func generateTests(_ code: String, language: ProgrammingLanguage? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        
        let prompt = """
        اكتب اختبارات وحدة (Unit Tests) للكود التالي.
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        أعد كود الاختبارات فقط.
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - توليد توثيق
    
    func generateDocumentation(_ code: String, language: ProgrammingLanguage? = nil) async -> String? {
        let langName = language?.displayName ?? "المكتشفة تلقائياً"
        
        let prompt = """
        اكتب توثيقاً احترافياً للكود التالي بالعربية.
        
        اللغة: \(langName)
        
        الكود:
        ```
        \(code)
        ```
        
        التوثيق يجب أن يتضمن:
        - وصف عام
        - المعاملات (Parameters)
        - القيمة المرجعة (Return Value)
        - أمثلة استخدام
        """
        
        return await processWithAI(prompt: prompt)
    }
    
    // MARK: - اكتشاف لغة البرمجة
    
    func detectLanguage(_ code: String) -> ProgrammingLanguage? {
        let code = code.lowercased()
        
        // Swift
        if code.contains("import foundation") || code.contains("import swiftui") ||
           code.contains("func ") && code.contains("-> ") ||
           code.contains("@state") || code.contains("@binding") {
            return .swift
        }
        
        // Python
        if code.contains("def ") || code.contains("import ") && code.contains(":") ||
           code.contains("print(") || code.contains("elif ") {
            return .python
        }
        
        // JavaScript/TypeScript
        if code.contains("const ") || code.contains("let ") || code.contains("function ") ||
           code.contains("=>") || code.contains("console.log") {
            if code.contains(": string") || code.contains(": number") || code.contains("interface ") {
                return .typescript
            }
            return .javascript
        }
        
        // Java
        if code.contains("public class") || code.contains("public static void main") ||
           code.contains("system.out.println") {
            return .java
        }
        
        // Kotlin
        if code.contains("fun ") && code.contains(":") || code.contains("val ") || code.contains("var ") {
            return .kotlin
        }
        
        // C#
        if code.contains("using system") || code.contains("namespace ") ||
           code.contains("console.writeline") {
            return .csharp
        }
        
        // C++
        if code.contains("#include") || code.contains("std::") || code.contains("cout") {
            return .cpp
        }
        
        // Go
        if code.contains("package main") || code.contains("func main()") || code.contains("fmt.") {
            return .go
        }
        
        // Rust
        if code.contains("fn main()") || code.contains("let mut") || code.contains("println!") {
            return .rust
        }
        
        // PHP
        if code.contains("<?php") || code.contains("echo ") || code.contains("$_") {
            return .php
        }
        
        // Ruby
        if code.contains("def ") && code.contains("end") || code.contains("puts ") {
            return .ruby
        }
        
        // SQL
        if code.contains("select ") || code.contains("insert into") || code.contains("create table") {
            return .sql
        }
        
        // HTML
        if code.contains("<html") || code.contains("<div") || code.contains("<body") {
            return .html
        }
        
        // CSS
        if code.contains("{") && code.contains("}") && (code.contains("color:") || code.contains("margin:") || code.contains("padding:")) {
            return .css
        }
        
        // Dart
        if code.contains("void main()") && code.contains("print(") || code.contains("widget") {
            return .dart
        }
        
        // Shell
        if code.contains("#!/bin/bash") || code.contains("echo ") && code.contains("$") {
            return .shell
        }
        
        return nil
    }
    
    // MARK: - معالجة AI
    
    private func processWithAI(prompt: String) async -> String? {
        await MainActor.run {
            isProcessing = true
            lastError = nil
        }
        
        defer {
            Task { @MainActor in
                isProcessing = false
            }
        }
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            await MainActor.run { lastError = "رابط غير صالح" }
            return nil
        }
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.3,
                "maxOutputTokens": 2048
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            await MainActor.run { lastError = "خطأ في تحويل البيانات" }
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 30
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                await MainActor.run { lastError = "خطأ في الاستجابة" }
                return nil
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let firstCandidate = candidates.first,
                  let content = firstCandidate["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let firstPart = parts.first,
                  let resultText = firstPart["text"] as? String else {
                await MainActor.run { lastError = "خطأ في قراءة الاستجابة" }
                return nil
            }
            
            // تنظيف النتيجة من علامات الكود
            var cleanResult = resultText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // إزالة ``` من البداية والنهاية
            if cleanResult.hasPrefix("```") {
                if let endOfFirstLine = cleanResult.firstIndex(of: "\n") {
                    cleanResult = String(cleanResult[cleanResult.index(after: endOfFirstLine)...])
                }
            }
            if cleanResult.hasSuffix("```") {
                cleanResult = String(cleanResult.dropLast(3))
            }
            
            await MainActor.run {
                lastResult = cleanResult.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            return lastResult
            
        } catch {
            await MainActor.run { lastError = error.localizedDescription }
            return nil
        }
    }
}
