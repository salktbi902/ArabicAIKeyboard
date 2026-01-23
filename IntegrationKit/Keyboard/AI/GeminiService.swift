//
//  GeminiService.swift
//  Arabic AI Keyboard
//
//  ✨ خدمة الذكاء الاصطناعي - Google Gemini API
//

import Foundation

// MARK: - أوامر الذكاء الاصطناعي

enum AICommand: String, CaseIterable, Identifiable {
    case proofread = "proofread"      // تدقيق لغوي
    case translate = "translate"      // ترجمة
    case diacritics = "diacritics"    // تشكيل
    case improve = "improve"          // تحسين
    case summarize = "summarize"      // تلخيص
    case expand = "expand"            // توسيع
    case formal = "formal"            // رسمي
    case casual = "casual"            // عامي
    case reply = "reply"              // رد ذكي
    case complete = "complete"        // إكمال
    
    var id: String { rawValue }
    
    /// الاسم بالعربي
    var titleAr: String {
        switch self {
        case .proofread: return "تدقيق"
        case .translate: return "ترجمة"
        case .diacritics: return "تشكيل"
        case .improve: return "تحسين"
        case .summarize: return "تلخيص"
        case .expand: return "توسيع"
        case .formal: return "رسمي"
        case .casual: return "عامي"
        case .reply: return "رد"
        case .complete: return "إكمال"
        }
    }
    
    /// الأيقونة
    var icon: String {
        switch self {
        case .proofread: return "eye"
        case .translate: return "globe"
        case .diacritics: return "textformat"
        case .improve: return "wand.and.stars"
        case .summarize: return "doc.text"
        case .expand: return "arrow.up.left.and.arrow.down.right"
        case .formal: return "briefcase"
        case .casual: return "face.smiling"
        case .reply: return "arrowshape.turn.up.left"
        case .complete: return "text.badge.plus"
        }
    }
    
    /// اللون
    var color: String {
        switch self {
        case .proofread: return "blue"
        case .translate: return "green"
        case .diacritics: return "purple"
        case .improve: return "orange"
        case .summarize: return "indigo"
        case .expand: return "teal"
        case .formal: return "gray"
        case .casual: return "pink"
        case .reply: return "cyan"
        case .complete: return "mint"
        }
    }
    
    /// الأمر للذكاء الاصطناعي
    var systemPrompt: String {
        switch self {
        case .proofread:
            return """
            أنت مدقق لغوي عربي محترف. صحح الأخطاء الإملائية والنحوية في النص التالي.
            أعد النص المصحح فقط بدون أي شرح أو تعليق.
            """
        case .translate:
            return """
            أنت مترجم محترف. إذا كان النص بالعربية، ترجمه للإنجليزية. إذا كان بالإنجليزية، ترجمه للعربية.
            أعد الترجمة فقط بدون أي شرح.
            """
        case .diacritics:
            return """
            أنت خبير في اللغة العربية. أضف التشكيل الكامل (الحركات) للنص العربي التالي.
            أعد النص مع التشكيل فقط.
            """
        case .improve:
            return """
            أنت كاتب محترف. حسّن أسلوب النص التالي ليكون أكثر وضوحاً وجمالاً.
            أعد النص المحسّن فقط.
            """
        case .summarize:
            return """
            لخّص النص التالي في جملة أو جملتين مع الحفاظ على المعنى الأساسي.
            أعد الملخص فقط.
            """
        case .expand:
            return """
            وسّع النص التالي بإضافة تفاصيل ومعلومات إضافية مع الحفاظ على الموضوع.
            أعد النص الموسّع فقط.
            """
        case .formal:
            return """
            حوّل النص التالي إلى أسلوب رسمي مناسب للمراسلات الرسمية والأعمال.
            أعد النص الرسمي فقط.
            """
        case .casual:
            return """
            حوّل النص التالي إلى أسلوب ودي وغير رسمي مناسب للمحادثات اليومية.
            أعد النص العامي فقط.
            """
        case .reply:
            return """
            اقترح رداً مناسباً على الرسالة التالية. الرد يجب أن يكون مهذباً ومناسباً للسياق.
            أعد الرد المقترح فقط.
            """
        case .complete:
            return """
            أكمل النص التالي بطريقة منطقية ومناسبة للسياق.
            أعد النص المكتمل فقط.
            """
        }
    }
}

// MARK: - خدمة Gemini

class GeminiService: ObservableObject {
    
    static let shared = GeminiService()
    
    // ✨ مفتاح API - استبدله بمفتاحك
    private let apiKey = "AIzaSyBe-R4ISfWhh2og7YyPVDpDSxzK4357dc8"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    @Published var isProcessing = false
    @Published var lastError: String?
    
    private init() {}
    
    /// معالجة النص مع أمر AI
    func process(_ text: String, command: AICommand) async -> String? {
        await MainActor.run {
            isProcessing = true
            lastError = nil
        }
        
        defer {
            Task { @MainActor in
                isProcessing = false
            }
        }
        
        let prompt = """
        \(command.systemPrompt)
        
        النص:
        \(text)
        """
        
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
                "temperature": 0.7,
                "maxOutputTokens": 1024
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run { lastError = "استجابة غير صالحة" }
                return nil
            }
            
            guard httpResponse.statusCode == 200 else {
                await MainActor.run { lastError = "خطأ: \(httpResponse.statusCode)" }
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
            
            return resultText.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            await MainActor.run { lastError = error.localizedDescription }
            return nil
        }
    }
}
