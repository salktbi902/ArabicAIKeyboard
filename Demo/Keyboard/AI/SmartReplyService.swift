//
//  SmartReplyService.swift
//  Arabic AI Keyboard
//
//  ✨ خدمة الردود الذكية - Smart Reply
//  تقترح ردود مناسبة بناءً على الرسالة المستلمة
//

import Foundation

// MARK: - نوع الرد

enum ReplyTone: String, CaseIterable, Identifiable {
    case positive = "positive"      // إيجابي
    case neutral = "neutral"        // محايد
    case formal = "formal"          // رسمي
    case friendly = "friendly"      // ودي
    
    var id: String { rawValue }
    
    var titleAr: String {
        switch self {
        case .positive: return "إيجابي"
        case .neutral: return "محايد"
        case .formal: return "رسمي"
        case .friendly: return "ودي"
        }
    }
    
    var emoji: String {
        switch self {
        case .positive: return "😊"
        case .neutral: return "😐"
        case .formal: return "👔"
        case .friendly: return "🤗"
        }
    }
}

// MARK: - نموذج الرد الذكي

struct SmartReply: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let tone: ReplyTone
    
    static func == (lhs: SmartReply, rhs: SmartReply) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - خدمة الردود الذكية

class SmartReplyService: ObservableObject {
    
    static let shared = SmartReplyService()
    
    // مفتاح API - نفس المفتاح المستخدم في GeminiService
    private let apiKey = "AIzaSyBe-R4ISfWhh2og7YyPVDpDSxzK4357dc8"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    @Published var isLoading = false
    @Published var replies: [SmartReply] = []
    @Published var lastError: String?
    
    private init() {}
    
    // MARK: - الردود السريعة الجاهزة
    
    /// ردود سريعة شائعة بدون AI
    static let quickReplies: [String: [String]] = [
        // التحيات
        "السلام عليكم": ["وعليكم السلام ورحمة الله", "وعليكم السلام", "أهلاً وسهلاً"],
        "مرحبا": ["أهلاً بك", "مرحباً", "هلا والله"],
        "صباح الخير": ["صباح النور", "صباح الورد", "صباح السعادة"],
        "مساء الخير": ["مساء النور", "مساء الورد", "مساء السعادة"],
        
        // الشكر
        "شكراً": ["العفو", "لا شكر على واجب", "تسلم"],
        "جزاك الله خير": ["وإياك", "آمين وإياك", "الله يجزاك خير"],
        
        // الأسئلة الشائعة
        "كيف حالك": ["الحمد لله بخير", "تمام الحمد لله", "بخير الله يسلمك"],
        "شو أخبارك": ["الحمد لله تمام", "كله تمام", "ماشي الحال"],
        "وين أنت": ["في البيت", "في الشغل", "في الطريق"],
        
        // الموافقة والرفض
        "تقدر تساعدني": ["طبعاً", "أكيد، تفضل", "إن شاء الله"],
        "ممكن": ["طبعاً ممكن", "أكيد", "إن شاء الله"],
        
        // الوداع
        "مع السلامة": ["الله يسلمك", "في أمان الله", "باي"],
        "باي": ["باي", "يلا مع السلامة", "الله يحفظك"],
    ]
    
    /// البحث عن ردود سريعة جاهزة
    func getQuickReplies(for message: String) -> [SmartReply] {
        let normalizedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        for (key, replies) in SmartReplyService.quickReplies {
            if normalizedMessage.contains(key.lowercased()) || key.lowercased().contains(normalizedMessage) {
                return replies.enumerated().map { index, reply in
                    let tone: ReplyTone = index == 0 ? .formal : (index == 1 ? .neutral : .friendly)
                    return SmartReply(text: reply, tone: tone)
                }
            }
        }
        
        return []
    }
    
    // MARK: - توليد الردود بالذكاء الاصطناعي
    
    /// توليد ردود ذكية باستخدام Gemini AI
    func generateSmartReplies(for message: String) async -> [SmartReply] {
        // أولاً: البحث عن ردود سريعة جاهزة
        let quickReplies = getQuickReplies(for: message)
        if !quickReplies.isEmpty {
            await MainActor.run {
                self.replies = quickReplies
            }
            return quickReplies
        }
        
        // ثانياً: توليد ردود بالذكاء الاصطناعي
        await MainActor.run {
            isLoading = true
            lastError = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let prompt = """
        أنت مساعد ذكي لاقتراح ردود على الرسائل. اقترح 4 ردود مختلفة على الرسالة التالية.
        
        الرسالة: "\(message)"
        
        اقترح 4 ردود بأنماط مختلفة:
        1. رد إيجابي ومتحمس
        2. رد محايد ومختصر
        3. رد رسمي ومهني
        4. رد ودي وعفوي
        
        أعد الردود بالتنسيق التالي (كل رد في سطر منفصل):
        POSITIVE: [الرد الإيجابي]
        NEUTRAL: [الرد المحايد]
        FORMAL: [الرد الرسمي]
        FRIENDLY: [الرد الودي]
        
        ملاحظات:
        - الردود يجب أن تكون قصيرة (جملة أو جملتين)
        - استخدم اللغة العربية الفصحى أو العامية حسب نبرة الرسالة الأصلية
        - لا تضف شرح أو تعليق، فقط الردود
        """
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            await MainActor.run { lastError = "رابط غير صالح" }
            return []
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
                "temperature": 0.8,
                "maxOutputTokens": 512
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            await MainActor.run { lastError = "خطأ في تحويل البيانات" }
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 15
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                await MainActor.run { lastError = "خطأ في الاستجابة" }
                return []
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let firstCandidate = candidates.first,
                  let content = firstCandidate["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let firstPart = parts.first,
                  let resultText = firstPart["text"] as? String else {
                await MainActor.run { lastError = "خطأ في قراءة الاستجابة" }
                return []
            }
            
            // تحليل الردود
            let parsedReplies = parseReplies(from: resultText)
            
            await MainActor.run {
                self.replies = parsedReplies
            }
            
            return parsedReplies
            
        } catch {
            await MainActor.run { lastError = error.localizedDescription }
            return []
        }
    }
    
    /// تحليل الردود من نص الاستجابة
    private func parseReplies(from text: String) -> [SmartReply] {
        var replies: [SmartReply] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.hasPrefix("POSITIVE:") {
                let replyText = trimmedLine.replacingOccurrences(of: "POSITIVE:", with: "").trimmingCharacters(in: .whitespaces)
                if !replyText.isEmpty {
                    replies.append(SmartReply(text: replyText, tone: .positive))
                }
            } else if trimmedLine.hasPrefix("NEUTRAL:") {
                let replyText = trimmedLine.replacingOccurrences(of: "NEUTRAL:", with: "").trimmingCharacters(in: .whitespaces)
                if !replyText.isEmpty {
                    replies.append(SmartReply(text: replyText, tone: .neutral))
                }
            } else if trimmedLine.hasPrefix("FORMAL:") {
                let replyText = trimmedLine.replacingOccurrences(of: "FORMAL:", with: "").trimmingCharacters(in: .whitespaces)
                if !replyText.isEmpty {
                    replies.append(SmartReply(text: replyText, tone: .formal))
                }
            } else if trimmedLine.hasPrefix("FRIENDLY:") {
                let replyText = trimmedLine.replacingOccurrences(of: "FRIENDLY:", with: "").trimmingCharacters(in: .whitespaces)
                if !replyText.isEmpty {
                    replies.append(SmartReply(text: replyText, tone: .friendly))
                }
            }
        }
        
        // إذا لم يتم تحليل الردود بشكل صحيح، نقسم النص
        if replies.isEmpty {
            let allLines = lines.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            for (index, line) in allLines.prefix(4).enumerated() {
                let cleanLine = line
                    .replacingOccurrences(of: "^\\d+\\.\\s*", with: "", options: .regularExpression)
                    .replacingOccurrences(of: "^-\\s*", with: "", options: .regularExpression)
                    .trimmingCharacters(in: .whitespaces)
                
                if !cleanLine.isEmpty {
                    let tone: ReplyTone = [.positive, .neutral, .formal, .friendly][index % 4]
                    replies.append(SmartReply(text: cleanLine, tone: tone))
                }
            }
        }
        
        return replies
    }
    
    /// مسح الردود
    func clearReplies() {
        replies = []
        lastError = nil
    }
}
