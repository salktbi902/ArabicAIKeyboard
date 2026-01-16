//
//  GeminiService.swift
//  ArabicAIKeyboard
//
//  خدمة التفاعل مع Google Gemini API
//  Created for Arabic AI Keyboard Enhancement
//

import Foundation

/// أنواع الأوامر الذكية المتاحة
enum AICommand: String, CaseIterable, Identifiable {
    case proofread = "proofread"
    case translate = "translate"
    case diacritics = "diacritics"
    case improve = "improve"
    case summarize = "summarize"
    case expand = "expand"
    case formal = "formal"
    case casual = "casual"
    case reply = "reply"
    case complete = "complete"
    
    var id: String { rawValue }
    
    /// اسم الأمر بالعربية
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
        case .reply: return "رد ذكي"
        case .complete: return "إكمال"
        }
    }
    
    /// أيقونة SF Symbol
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
    
    /// لون الأيقونة
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
    
    /// الأمر البرمجي (System Prompt)
    var systemPrompt: String {
        switch self {
        case .proofread:
            return """
            أنت مدقق لغوي محترف للغة العربية. مهمتك:
            1. تصحيح الأخطاء الإملائية والنحوية
            2. تحسين علامات الترقيم
            3. الحفاظ على المعنى الأصلي
            أرجع النص المصحح فقط بدون أي شرح.
            """
        case .translate:
            return """
            أنت مترجم محترف. مهمتك:
            1. إذا كان النص بالعربية، ترجمه إلى الإنجليزية
            2. إذا كان النص بالإنجليزية، ترجمه إلى العربية
            3. حافظ على أسلوب ونبرة النص
            أرجع الترجمة فقط بدون أي شرح.
            """
        case .diacritics:
            return """
            أنت خبير في اللغة العربية. مهمتك:
            1. إضافة التشكيل الكامل للنص العربي (الفتحة، الضمة، الكسرة، السكون، الشدة، التنوين)
            2. التشكيل يجب أن يكون صحيحاً نحوياً وصرفياً
            أرجع النص مشكّلاً فقط بدون أي شرح.
            """
        case .improve:
            return """
            أنت كاتب محترف. مهمتك:
            1. تحسين أسلوب الكتابة
            2. جعل النص أكثر وضوحاً وجاذبية
            3. الحفاظ على المعنى الأصلي
            أرجع النص المحسن فقط بدون أي شرح.
            """
        case .summarize:
            return """
            أنت ملخص نصوص محترف. مهمتك:
            1. تلخيص النص بشكل موجز ومفيد
            2. الحفاظ على النقاط الرئيسية
            3. استخدام نفس لغة النص
            أرجع الملخص فقط بدون أي شرح.
            """
        case .expand:
            return """
            أنت كاتب محترف. مهمتك:
            1. توسيع النص وإضافة تفاصيل مفيدة
            2. الحفاظ على الفكرة الأساسية
            3. جعل النص أكثر شمولاً
            أرجع النص الموسع فقط بدون أي شرح.
            """
        case .formal:
            return """
            أنت خبير في الكتابة الرسمية. مهمتك:
            1. تحويل النص إلى صياغة رسمية واحترافية
            2. استخدام مفردات مناسبة للمراسلات الرسمية
            3. الحفاظ على المعنى
            أرجع النص الرسمي فقط بدون أي شرح.
            """
        case .casual:
            return """
            أنت كاتب محتوى عصري. مهمتك:
            1. تحويل النص إلى صياغة عامية وودية
            2. استخدام أسلوب محادثة طبيعي
            3. الحفاظ على المعنى
            أرجع النص العامي فقط بدون أي شرح.
            """
        case .reply:
            return """
            أنت مساعد ذكي. مهمتك:
            1. اقتراح رد مناسب على الرسالة
            2. الرد يجب أن يكون مهذباً ومناسباً للسياق
            3. استخدام نفس لغة الرسالة
            أرجع الرد المقترح فقط بدون أي شرح.
            """
        case .complete:
            return """
            أنت مساعد كتابة ذكي. مهمتك:
            1. إكمال النص بشكل منطقي ومتسق
            2. الحفاظ على أسلوب الكتابة
            3. إضافة جملة أو جملتين فقط
            أرجع النص الكامل (الأصلي + الإكمال) بدون أي شرح.
            """
        }
    }
}

/// حالة المعالجة
enum AIProcessingState {
    case idle
    case processing
    case success(String)
    case error(String)
}

/// خدمة Gemini للذكاء الاصطناعي
@MainActor
class GeminiService: ObservableObject {
    
    /// النسخة الوحيدة (Singleton)
    static let shared = GeminiService()
    
    /// حالة المعالجة الحالية
    @Published var state: AIProcessingState = .idle
    
    /// مفتاح API
    private let apiKey = "AIzaSyBe-R4ISfWhh2og7YyPVDpDSxzK4357dc8"
    
    /// رابط API
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    private init() {}
    
    /// معالجة النص باستخدام أمر معين
    func process(_ text: String, command: AICommand) async -> String? {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state = .error("النص فارغ")
            return nil
        }
        
        state = .processing
        
        do {
            let result = try await callGeminiAPI(text: text, systemPrompt: command.systemPrompt)
            state = .success(result)
            return result
        } catch {
            state = .error(error.localizedDescription)
            return nil
        }
    }
    
    /// استدعاء Gemini API
    private func callGeminiAPI(text: String, systemPrompt: String) async throws -> String {
        let url = URL(string: "\(baseURL)?key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": "\(systemPrompt)\n\nالنص:\n\(text)"]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.7,
                "topP": 0.95,
                "topK": 40,
                "maxOutputTokens": 2048
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "GeminiAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "فشل في الاتصال بالخادم"])
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let resultText = firstPart["text"] as? String else {
            throw NSError(domain: "GeminiAPI", code: -2, userInfo: [NSLocalizedDescriptionKey: "استجابة غير صالحة"])
        }
        
        return resultText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// إعادة تعيين الحالة
    func reset() {
        state = .idle
    }
}
