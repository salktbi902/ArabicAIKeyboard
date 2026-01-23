# 🎹 دليل دمج الكيبورد العربي الذكي

دليل شامل لدمج الكيبورد العربي الذكي في تطبيق iOS الخاص بك.

---

## 📋 المتطلبات

| المتطلب | الحد الأدنى |
|---------|-------------|
| iOS | 15.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| حساب Apple Developer | مطلوب |

---

## 🚀 خطوات الدمج

### الخطوة 1: إضافة Keyboard Extension

1. افتح مشروعك في **Xcode**
2. اذهب إلى **File > New > Target**
3. اختر **iOS > Custom Keyboard Extension**
4. أدخل اسماً: `ArabicKeyboard`
5. اضغط **Finish**

### الخطوة 2: إضافة التبعيات

#### باستخدام Swift Package Manager:

1. **File > Add Package Dependencies**
2. أضف الحزم التالية:

```
https://github.com/KeyboardKit/KeyboardKit.git (9.0.0+)
https://github.com/google/generative-ai-swift.git (0.5.0+)
```

3. أضف الحزم لـ **Keyboard Extension Target**

### الخطوة 3: نسخ الملفات

انسخ المجلدات التالية إلى مشروعك:

```
IntegrationKit/
├── Keyboard/
│   └── KeyboardViewController.swift    → YourApp/Keyboard/
├── Shared/
│   └── AppConfig.swift                 → YourApp/Shared/
└── Resources/
    └── Keyboard-Info.plist             → YourApp/Keyboard/
```

ثم انسخ من المشروع الرئيسي:

```
Demo/Keyboard/AI/                        → YourApp/Keyboard/AI/
Demo/Keyboard/Code/                      → YourApp/Keyboard/Code/
```

### الخطوة 4: تعديل AppConfig.swift

افتح `AppConfig.swift` وغيّر القيم التالية:

```swift
// غيّر لمعرف تطبيقك
static let mainAppBundleId = "com.yourcompany.yourapp"

// أضف مفتاح Gemini API
static var geminiAPIKey: String {
    return "YOUR_GEMINI_API_KEY"
}
```

### الخطوة 5: إعداد App Groups

1. اختر **Main App Target**
2. **Signing & Capabilities > + Capability > App Groups**
3. أضف: `group.com.yourcompany.yourapp`
4. كرر نفس الخطوات لـ **Keyboard Extension Target**

### الخطوة 6: تعديل Info.plist

استبدل محتوى `Info.plist` للكيبورد بمحتوى `Keyboard-Info.plist` المرفق.

### الخطوة 7: البناء والاختبار

1. اختر **Keyboard Extension** كـ Scheme
2. اضغط **Run**
3. اختر تطبيق للاختبار (مثل Notes)

---

## ⚙️ الإعداد بعد التثبيت

### تفعيل الكيبورد على الجهاز:

1. **الإعدادات > عام > لوحة المفاتيح > لوحات المفاتيح**
2. **إضافة لوحة مفاتيح جديدة**
3. اختر **اسم تطبيقك**
4. فعّل **"السماح بالوصول الكامل"**

---

## 📁 هيكل الملفات النهائي

```
YourApp/
├── YourApp/                          ← التطبيق الرئيسي
│   ├── AppDelegate.swift
│   ├── ContentView.swift
│   └── ...
│
├── Keyboard/                         ← Keyboard Extension
│   ├── KeyboardViewController.swift  ← وحدة التحكم الرئيسية
│   ├── Info.plist
│   │
│   ├── AI/                          ← ميزات الذكاء الاصطناعي
│   │   ├── GeminiService.swift
│   │   ├── AIMenu.swift
│   │   ├── AICommand.swift
│   │   ├── SmartReplyService.swift
│   │   └── SmartReplyView.swift
│   │
│   └── Code/                        ← أدوات البرمجة
│       ├── CodeService.swift
│       ├── CodeSnippets.swift
│       ├── CodeToolsView.swift
│       └── ProgrammerKeyboard.swift
│
└── Shared/                          ← ملفات مشتركة
    └── AppConfig.swift
```

---

## 🔑 إعداد مفتاح Gemini API

### الحصول على المفتاح:

1. اذهب إلى [Google AI Studio](https://aistudio.google.com/)
2. سجل الدخول بحساب Google
3. اضغط **Get API Key**
4. انسخ المفتاح

### إضافة المفتاح للتطبيق:

#### الطريقة 1: في AppConfig (للتطوير فقط)

```swift
static var geminiAPIKey: String {
    return "AIzaSy..."
}
```

#### الطريقة 2: من التطبيق الرئيسي (موصى به)

في التطبيق الرئيسي، أضف شاشة إعدادات:

```swift
func saveAPIKey(_ key: String) {
    AppConfig.saveGeminiAPIKey(key)
}
```

#### الطريقة 3: Environment Variable (للإنتاج)

```swift
static var geminiAPIKey: String {
    return ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? ""
}
```

---

## 🎨 تخصيص الكيبورد

### تغيير الثيم:

```swift
// في KeyboardViewController.swift
private func setupAppearance() {
    state.themeContext.theme = .init(
        background: .color(.blue),
        foreground: .color(.white)
    )
}
```

### إضافة لغات:

```swift
private func setupLocales() {
    state.keyboardContext.locales = [
        Locale(identifier: "ar"),
        Locale(identifier: "en"),
        Locale(identifier: "fr"),
    ]
}
```

### تعطيل ميزات:

```swift
// في AppConfig.swift
struct Features {
    static var isAIEnabled: Bool { return false }
    static var isCodeToolsEnabled: Bool { return false }
}
```

---

## 🐛 حل المشاكل الشائعة

### المشكلة: الكيبورد لا يظهر

**الحل:**
1. تأكد من إضافة الكيبورد في الإعدادات
2. تأكد من تفعيل "السماح بالوصول الكامل"
3. أعد تشغيل الجهاز

### المشكلة: ميزات AI لا تعمل

**الحل:**
1. تأكد من صحة مفتاح Gemini API
2. تأكد من اتصال الإنترنت
3. تأكد من تفعيل "السماح بالوصول الكامل"

### المشكلة: خطأ في App Groups

**الحل:**
1. تأكد من تطابق معرف App Group في كلا الـ Targets
2. تأكد من تفعيل App Groups في Apple Developer Portal

### المشكلة: الكيبورد بطيء

**الحل:**
1. قلل عدد الميزات المفعلة
2. استخدم الردود المحلية بدلاً من AI
3. فعّل التخزين المؤقت

---

## 📞 الدعم

للمساعدة أو الإبلاغ عن مشاكل:

- **GitHub Issues:** [ArabicAIKeyboard](https://github.com/salktbi902/ArabicAIKeyboard/issues)
- **البريد:** support@yourapp.com

---

## 📄 الترخيص

هذا المشروع مرخص تحت MIT License.

---

**تم إنشاؤه بواسطة Manus AI** 🤖
