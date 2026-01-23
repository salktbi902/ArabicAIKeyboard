//
//  CodeSnippets.swift
//  Arabic AI Keyboard
//
//  📚 مكتبة قوالب الكود الجاهزة
//  تشمل قوالب للغات: Swift, Python, JavaScript, Java, وغيرها
//

import Foundation

// MARK: - نموذج القالب

struct CodeSnippet: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let titleAr: String
    let code: String
    let language: ProgrammingLanguage
    let category: SnippetCategory
    let description: String
    
    static func == (lhs: CodeSnippet, rhs: CodeSnippet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - فئات القوالب

enum SnippetCategory: String, CaseIterable, Identifiable {
    case basics = "basics"
    case functions = "functions"
    case loops = "loops"
    case conditions = "conditions"
    case classes = "classes"
    case dataStructures = "data_structures"
    case fileIO = "file_io"
    case networking = "networking"
    case async = "async"
    case ui = "ui"
    case database = "database"
    case testing = "testing"
    
    var id: String { rawValue }
    
    var titleAr: String {
        switch self {
        case .basics: return "أساسيات"
        case .functions: return "الدوال"
        case .loops: return "الحلقات"
        case .conditions: return "الشروط"
        case .classes: return "الكلاسات"
        case .dataStructures: return "هياكل البيانات"
        case .fileIO: return "الملفات"
        case .networking: return "الشبكات"
        case .async: return "البرمجة غير المتزامنة"
        case .ui: return "واجهة المستخدم"
        case .database: return "قواعد البيانات"
        case .testing: return "الاختبارات"
        }
    }
    
    var icon: String {
        switch self {
        case .basics: return "book"
        case .functions: return "function"
        case .loops: return "repeat"
        case .conditions: return "arrow.triangle.branch"
        case .classes: return "cube"
        case .dataStructures: return "list.bullet.rectangle"
        case .fileIO: return "doc"
        case .networking: return "network"
        case .async: return "clock.arrow.2.circlepath"
        case .ui: return "rectangle.on.rectangle"
        case .database: return "cylinder"
        case .testing: return "checkmark.shield"
        }
    }
}

// MARK: - مكتبة القوالب

class CodeSnippetsLibrary {
    
    static let shared = CodeSnippetsLibrary()
    
    private init() {}
    
    // MARK: - الحصول على القوالب
    
    func getSnippets(for language: ProgrammingLanguage) -> [CodeSnippet] {
        switch language {
        case .swift: return swiftSnippets
        case .python: return pythonSnippets
        case .javascript: return javascriptSnippets
        case .java: return javaSnippets
        case .kotlin: return kotlinSnippets
        case .typescript: return typescriptSnippets
        case .csharp: return csharpSnippets
        case .cpp: return cppSnippets
        case .go: return goSnippets
        case .sql: return sqlSnippets
        case .html: return htmlSnippets
        case .css: return cssSnippets
        case .dart: return dartSnippets
        case .shell: return shellSnippets
        default: return []
        }
    }
    
    func getSnippets(for language: ProgrammingLanguage, category: SnippetCategory) -> [CodeSnippet] {
        return getSnippets(for: language).filter { $0.category == category }
    }
    
    func searchSnippets(query: String, language: ProgrammingLanguage? = nil) -> [CodeSnippet] {
        let allSnippets = language.map { getSnippets(for: $0) } ?? ProgrammingLanguage.allCases.flatMap { getSnippets(for: $0) }
        
        let lowercasedQuery = query.lowercased()
        return allSnippets.filter {
            $0.title.lowercased().contains(lowercasedQuery) ||
            $0.titleAr.contains(query) ||
            $0.description.lowercased().contains(lowercasedQuery)
        }
    }
    
    // MARK: - Swift Snippets
    
    var swiftSnippets: [CodeSnippet] {
        [
            // أساسيات
            CodeSnippet(
                title: "Variable Declaration",
                titleAr: "تعريف متغير",
                code: "var variableName: Type = value",
                language: .swift,
                category: .basics,
                description: "تعريف متغير قابل للتغيير"
            ),
            CodeSnippet(
                title: "Constant Declaration",
                titleAr: "تعريف ثابت",
                code: "let constantName: Type = value",
                language: .swift,
                category: .basics,
                description: "تعريف ثابت غير قابل للتغيير"
            ),
            CodeSnippet(
                title: "Print Statement",
                titleAr: "طباعة",
                code: "print(\"Hello, World!\")",
                language: .swift,
                category: .basics,
                description: "طباعة نص في الكونسول"
            ),
            CodeSnippet(
                title: "String Interpolation",
                titleAr: "دمج النصوص",
                code: "let message = \"Hello, \\(name)!\"",
                language: .swift,
                category: .basics,
                description: "دمج متغيرات داخل النص"
            ),
            
            // الدوال
            CodeSnippet(
                title: "Function",
                titleAr: "دالة",
                code: """
func functionName(parameter: Type) -> ReturnType {
    // الكود هنا
    return value
}
""",
                language: .swift,
                category: .functions,
                description: "تعريف دالة مع معاملات وقيمة مرجعة"
            ),
            CodeSnippet(
                title: "Closure",
                titleAr: "كلوجر",
                code: """
let closure: (Type) -> ReturnType = { parameter in
    return value
}
""",
                language: .swift,
                category: .functions,
                description: "تعريف كلوجر (دالة مجهولة)"
            ),
            
            // الحلقات
            CodeSnippet(
                title: "For Loop",
                titleAr: "حلقة for",
                code: """
for item in collection {
    // الكود هنا
}
""",
                language: .swift,
                category: .loops,
                description: "حلقة للمرور على عناصر مجموعة"
            ),
            CodeSnippet(
                title: "For Range",
                titleAr: "حلقة نطاق",
                code: """
for i in 0..<10 {
    print(i)
}
""",
                language: .swift,
                category: .loops,
                description: "حلقة للمرور على نطاق أرقام"
            ),
            CodeSnippet(
                title: "While Loop",
                titleAr: "حلقة while",
                code: """
while condition {
    // الكود هنا
}
""",
                language: .swift,
                category: .loops,
                description: "حلقة تستمر طالما الشرط صحيح"
            ),
            
            // الشروط
            CodeSnippet(
                title: "If Statement",
                titleAr: "جملة if",
                code: """
if condition {
    // الكود هنا
} else if anotherCondition {
    // الكود هنا
} else {
    // الكود هنا
}
""",
                language: .swift,
                category: .conditions,
                description: "جملة شرطية"
            ),
            CodeSnippet(
                title: "Switch Statement",
                titleAr: "جملة switch",
                code: """
switch value {
case .option1:
    // الكود هنا
case .option2:
    // الكود هنا
default:
    // الكود الافتراضي
}
""",
                language: .swift,
                category: .conditions,
                description: "جملة تبديل للحالات المتعددة"
            ),
            CodeSnippet(
                title: "Guard Statement",
                titleAr: "جملة guard",
                code: """
guard let unwrapped = optional else {
    return
}
// استخدم unwrapped هنا
""",
                language: .swift,
                category: .conditions,
                description: "فك القيمة الاختيارية مع الخروج المبكر"
            ),
            
            // الكلاسات
            CodeSnippet(
                title: "Class",
                titleAr: "كلاس",
                code: """
class ClassName {
    var property: Type
    
    init(property: Type) {
        self.property = property
    }
    
    func method() {
        // الكود هنا
    }
}
""",
                language: .swift,
                category: .classes,
                description: "تعريف كلاس مع خصائص ودوال"
            ),
            CodeSnippet(
                title: "Struct",
                titleAr: "ستركت",
                code: """
struct StructName {
    var property: Type
    
    func method() {
        // الكود هنا
    }
}
""",
                language: .swift,
                category: .classes,
                description: "تعريف ستركت (نوع قيمة)"
            ),
            CodeSnippet(
                title: "Enum",
                titleAr: "تعداد",
                code: """
enum EnumName {
    case option1
    case option2
    case option3
}
""",
                language: .swift,
                category: .classes,
                description: "تعريف تعداد"
            ),
            CodeSnippet(
                title: "Protocol",
                titleAr: "بروتوكول",
                code: """
protocol ProtocolName {
    var property: Type { get set }
    func method()
}
""",
                language: .swift,
                category: .classes,
                description: "تعريف بروتوكول"
            ),
            
            // هياكل البيانات
            CodeSnippet(
                title: "Array",
                titleAr: "مصفوفة",
                code: "var array: [Type] = [item1, item2, item3]",
                language: .swift,
                category: .dataStructures,
                description: "تعريف مصفوفة"
            ),
            CodeSnippet(
                title: "Dictionary",
                titleAr: "قاموس",
                code: "var dict: [KeyType: ValueType] = [key1: value1, key2: value2]",
                language: .swift,
                category: .dataStructures,
                description: "تعريف قاموس"
            ),
            CodeSnippet(
                title: "Set",
                titleAr: "مجموعة",
                code: "var set: Set<Type> = [item1, item2, item3]",
                language: .swift,
                category: .dataStructures,
                description: "تعريف مجموعة (بدون تكرار)"
            ),
            
            // البرمجة غير المتزامنة
            CodeSnippet(
                title: "Async Function",
                titleAr: "دالة غير متزامنة",
                code: """
func fetchData() async throws -> Data {
    let (data, _) = try await URLSession.shared.data(from: url)
    return data
}
""",
                language: .swift,
                category: .async,
                description: "دالة غير متزامنة مع async/await"
            ),
            CodeSnippet(
                title: "Task",
                titleAr: "مهمة",
                code: """
Task {
    do {
        let result = try await fetchData()
        // استخدم النتيجة
    } catch {
        print("Error: \\(error)")
    }
}
""",
                language: .swift,
                category: .async,
                description: "تشغيل كود غير متزامن"
            ),
            
            // واجهة المستخدم (SwiftUI)
            CodeSnippet(
                title: "SwiftUI View",
                titleAr: "واجهة SwiftUI",
                code: """
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Tap Me") {
                // الإجراء هنا
            }
        }
    }
}
""",
                language: .swift,
                category: .ui,
                description: "واجهة SwiftUI بسيطة"
            ),
            CodeSnippet(
                title: "State Variable",
                titleAr: "متغير حالة",
                code: "@State private var value: Type = initialValue",
                language: .swift,
                category: .ui,
                description: "متغير حالة في SwiftUI"
            ),
            
            // الشبكات
            CodeSnippet(
                title: "URL Request",
                titleAr: "طلب شبكة",
                code: """
func fetchData() async throws -> Data {
    guard let url = URL(string: "https://api.example.com/data") else {
        throw URLError(.badURL)
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    return data
}
""",
                language: .swift,
                category: .networking,
                description: "طلب GET بسيط"
            ),
        ]
    }
    
    // MARK: - Python Snippets
    
    var pythonSnippets: [CodeSnippet] {
        [
            // أساسيات
            CodeSnippet(
                title: "Variable",
                titleAr: "متغير",
                code: "variable_name = value",
                language: .python,
                category: .basics,
                description: "تعريف متغير"
            ),
            CodeSnippet(
                title: "Print",
                titleAr: "طباعة",
                code: "print(\"Hello, World!\")",
                language: .python,
                category: .basics,
                description: "طباعة نص"
            ),
            CodeSnippet(
                title: "F-String",
                titleAr: "نص منسق",
                code: "message = f\"Hello, {name}!\"",
                language: .python,
                category: .basics,
                description: "نص منسق مع متغيرات"
            ),
            CodeSnippet(
                title: "Input",
                titleAr: "إدخال",
                code: "user_input = input(\"Enter value: \")",
                language: .python,
                category: .basics,
                description: "قراءة إدخال المستخدم"
            ),
            
            // الدوال
            CodeSnippet(
                title: "Function",
                titleAr: "دالة",
                code: """
def function_name(parameter):
    # الكود هنا
    return value
""",
                language: .python,
                category: .functions,
                description: "تعريف دالة"
            ),
            CodeSnippet(
                title: "Lambda",
                titleAr: "لامبدا",
                code: "square = lambda x: x ** 2",
                language: .python,
                category: .functions,
                description: "دالة مجهولة"
            ),
            CodeSnippet(
                title: "Decorator",
                titleAr: "مزخرف",
                code: """
def decorator(func):
    def wrapper(*args, **kwargs):
        # قبل الدالة
        result = func(*args, **kwargs)
        # بعد الدالة
        return result
    return wrapper

@decorator
def my_function():
    pass
""",
                language: .python,
                category: .functions,
                description: "تعريف واستخدام مزخرف"
            ),
            
            // الحلقات
            CodeSnippet(
                title: "For Loop",
                titleAr: "حلقة for",
                code: """
for item in collection:
    # الكود هنا
""",
                language: .python,
                category: .loops,
                description: "حلقة للمرور على عناصر"
            ),
            CodeSnippet(
                title: "For Range",
                titleAr: "حلقة نطاق",
                code: """
for i in range(10):
    print(i)
""",
                language: .python,
                category: .loops,
                description: "حلقة للمرور على نطاق"
            ),
            CodeSnippet(
                title: "While Loop",
                titleAr: "حلقة while",
                code: """
while condition:
    # الكود هنا
""",
                language: .python,
                category: .loops,
                description: "حلقة while"
            ),
            CodeSnippet(
                title: "List Comprehension",
                titleAr: "اختصار القائمة",
                code: "squares = [x**2 for x in range(10)]",
                language: .python,
                category: .loops,
                description: "إنشاء قائمة باختصار"
            ),
            
            // الشروط
            CodeSnippet(
                title: "If Statement",
                titleAr: "جملة if",
                code: """
if condition:
    # الكود هنا
elif another_condition:
    # الكود هنا
else:
    # الكود هنا
""",
                language: .python,
                category: .conditions,
                description: "جملة شرطية"
            ),
            CodeSnippet(
                title: "Ternary",
                titleAr: "شرط مختصر",
                code: "result = value_if_true if condition else value_if_false",
                language: .python,
                category: .conditions,
                description: "شرط في سطر واحد"
            ),
            
            // الكلاسات
            CodeSnippet(
                title: "Class",
                titleAr: "كلاس",
                code: """
class ClassName:
    def __init__(self, parameter):
        self.property = parameter
    
    def method(self):
        # الكود هنا
        pass
""",
                language: .python,
                category: .classes,
                description: "تعريف كلاس"
            ),
            CodeSnippet(
                title: "Inheritance",
                titleAr: "وراثة",
                code: """
class ChildClass(ParentClass):
    def __init__(self, parameter):
        super().__init__(parameter)
""",
                language: .python,
                category: .classes,
                description: "كلاس يرث من كلاس آخر"
            ),
            
            // هياكل البيانات
            CodeSnippet(
                title: "List",
                titleAr: "قائمة",
                code: "my_list = [1, 2, 3, 4, 5]",
                language: .python,
                category: .dataStructures,
                description: "تعريف قائمة"
            ),
            CodeSnippet(
                title: "Dictionary",
                titleAr: "قاموس",
                code: "my_dict = {\"key1\": \"value1\", \"key2\": \"value2\"}",
                language: .python,
                category: .dataStructures,
                description: "تعريف قاموس"
            ),
            CodeSnippet(
                title: "Tuple",
                titleAr: "صف",
                code: "my_tuple = (1, 2, 3)",
                language: .python,
                category: .dataStructures,
                description: "تعريف صف (غير قابل للتغيير)"
            ),
            CodeSnippet(
                title: "Set",
                titleAr: "مجموعة",
                code: "my_set = {1, 2, 3}",
                language: .python,
                category: .dataStructures,
                description: "تعريف مجموعة"
            ),
            
            // الملفات
            CodeSnippet(
                title: "Read File",
                titleAr: "قراءة ملف",
                code: """
with open("file.txt", "r", encoding="utf-8") as f:
    content = f.read()
""",
                language: .python,
                category: .fileIO,
                description: "قراءة محتوى ملف"
            ),
            CodeSnippet(
                title: "Write File",
                titleAr: "كتابة ملف",
                code: """
with open("file.txt", "w", encoding="utf-8") as f:
    f.write("Hello, World!")
""",
                language: .python,
                category: .fileIO,
                description: "كتابة في ملف"
            ),
            
            // البرمجة غير المتزامنة
            CodeSnippet(
                title: "Async Function",
                titleAr: "دالة غير متزامنة",
                code: """
import asyncio

async def fetch_data():
    # الكود هنا
    await asyncio.sleep(1)
    return data

# التشغيل
asyncio.run(fetch_data())
""",
                language: .python,
                category: .async,
                description: "دالة غير متزامنة"
            ),
            
            // الشبكات
            CodeSnippet(
                title: "HTTP Request",
                titleAr: "طلب HTTP",
                code: """
import requests

response = requests.get("https://api.example.com/data")
if response.status_code == 200:
    data = response.json()
""",
                language: .python,
                category: .networking,
                description: "طلب GET باستخدام requests"
            ),
        ]
    }
    
    // MARK: - JavaScript Snippets
    
    var javascriptSnippets: [CodeSnippet] {
        [
            // أساسيات
            CodeSnippet(
                title: "Variable (let)",
                titleAr: "متغير let",
                code: "let variableName = value;",
                language: .javascript,
                category: .basics,
                description: "تعريف متغير قابل للتغيير"
            ),
            CodeSnippet(
                title: "Constant",
                titleAr: "ثابت",
                code: "const constantName = value;",
                language: .javascript,
                category: .basics,
                description: "تعريف ثابت"
            ),
            CodeSnippet(
                title: "Console Log",
                titleAr: "طباعة",
                code: "console.log(\"Hello, World!\");",
                language: .javascript,
                category: .basics,
                description: "طباعة في الكونسول"
            ),
            CodeSnippet(
                title: "Template Literal",
                titleAr: "نص قالب",
                code: "const message = `Hello, ${name}!`;",
                language: .javascript,
                category: .basics,
                description: "نص مع متغيرات"
            ),
            
            // الدوال
            CodeSnippet(
                title: "Function",
                titleAr: "دالة",
                code: """
function functionName(parameter) {
    // الكود هنا
    return value;
}
""",
                language: .javascript,
                category: .functions,
                description: "تعريف دالة"
            ),
            CodeSnippet(
                title: "Arrow Function",
                titleAr: "دالة سهمية",
                code: "const functionName = (parameter) => value;",
                language: .javascript,
                category: .functions,
                description: "دالة سهمية مختصرة"
            ),
            CodeSnippet(
                title: "Async Function",
                titleAr: "دالة غير متزامنة",
                code: """
async function fetchData() {
    try {
        const response = await fetch(url);
        const data = await response.json();
        return data;
    } catch (error) {
        console.error(error);
    }
}
""",
                language: .javascript,
                category: .functions,
                description: "دالة غير متزامنة"
            ),
            
            // الحلقات
            CodeSnippet(
                title: "For Loop",
                titleAr: "حلقة for",
                code: """
for (let i = 0; i < 10; i++) {
    console.log(i);
}
""",
                language: .javascript,
                category: .loops,
                description: "حلقة for تقليدية"
            ),
            CodeSnippet(
                title: "For...of",
                titleAr: "حلقة for...of",
                code: """
for (const item of array) {
    console.log(item);
}
""",
                language: .javascript,
                category: .loops,
                description: "حلقة للمرور على العناصر"
            ),
            CodeSnippet(
                title: "forEach",
                titleAr: "forEach",
                code: """
array.forEach((item, index) => {
    console.log(item, index);
});
""",
                language: .javascript,
                category: .loops,
                description: "دالة forEach على المصفوفة"
            ),
            CodeSnippet(
                title: "Map",
                titleAr: "تحويل map",
                code: "const newArray = array.map(item => item * 2);",
                language: .javascript,
                category: .loops,
                description: "تحويل عناصر المصفوفة"
            ),
            CodeSnippet(
                title: "Filter",
                titleAr: "تصفية filter",
                code: "const filtered = array.filter(item => item > 5);",
                language: .javascript,
                category: .loops,
                description: "تصفية عناصر المصفوفة"
            ),
            
            // الشروط
            CodeSnippet(
                title: "If Statement",
                titleAr: "جملة if",
                code: """
if (condition) {
    // الكود هنا
} else if (anotherCondition) {
    // الكود هنا
} else {
    // الكود هنا
}
""",
                language: .javascript,
                category: .conditions,
                description: "جملة شرطية"
            ),
            CodeSnippet(
                title: "Ternary",
                titleAr: "شرط مختصر",
                code: "const result = condition ? valueIfTrue : valueIfFalse;",
                language: .javascript,
                category: .conditions,
                description: "شرط في سطر واحد"
            ),
            CodeSnippet(
                title: "Optional Chaining",
                titleAr: "سلسلة اختيارية",
                code: "const value = object?.property?.nestedProperty;",
                language: .javascript,
                category: .conditions,
                description: "الوصول الآمن للخصائص"
            ),
            
            // الكلاسات
            CodeSnippet(
                title: "Class",
                titleAr: "كلاس",
                code: """
class ClassName {
    constructor(parameter) {
        this.property = parameter;
    }
    
    method() {
        // الكود هنا
    }
}
""",
                language: .javascript,
                category: .classes,
                description: "تعريف كلاس"
            ),
            
            // هياكل البيانات
            CodeSnippet(
                title: "Array",
                titleAr: "مصفوفة",
                code: "const array = [1, 2, 3, 4, 5];",
                language: .javascript,
                category: .dataStructures,
                description: "تعريف مصفوفة"
            ),
            CodeSnippet(
                title: "Object",
                titleAr: "كائن",
                code: """
const object = {
    key1: "value1",
    key2: "value2"
};
""",
                language: .javascript,
                category: .dataStructures,
                description: "تعريف كائن"
            ),
            CodeSnippet(
                title: "Destructuring",
                titleAr: "تفكيك",
                code: "const { property1, property2 } = object;",
                language: .javascript,
                category: .dataStructures,
                description: "تفكيك الكائن"
            ),
            CodeSnippet(
                title: "Spread Operator",
                titleAr: "عامل الانتشار",
                code: "const newArray = [...array1, ...array2];",
                language: .javascript,
                category: .dataStructures,
                description: "دمج المصفوفات"
            ),
            
            // الشبكات
            CodeSnippet(
                title: "Fetch API",
                titleAr: "طلب Fetch",
                code: """
fetch("https://api.example.com/data")
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(error => console.error(error));
""",
                language: .javascript,
                category: .networking,
                description: "طلب GET باستخدام Fetch"
            ),
            CodeSnippet(
                title: "Fetch POST",
                titleAr: "طلب POST",
                code: """
fetch("https://api.example.com/data", {
    method: "POST",
    headers: {
        "Content-Type": "application/json"
    },
    body: JSON.stringify({ key: "value" })
})
    .then(response => response.json())
    .then(data => console.log(data));
""",
                language: .javascript,
                category: .networking,
                description: "طلب POST باستخدام Fetch"
            ),
        ]
    }
    
    // MARK: - Java Snippets
    
    var javaSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Main Method",
                titleAr: "الدالة الرئيسية",
                code: """
public static void main(String[] args) {
    // الكود هنا
}
""",
                language: .java,
                category: .basics,
                description: "نقطة بداية البرنامج"
            ),
            CodeSnippet(
                title: "Print",
                titleAr: "طباعة",
                code: "System.out.println(\"Hello, World!\");",
                language: .java,
                category: .basics,
                description: "طباعة نص"
            ),
            CodeSnippet(
                title: "Class",
                titleAr: "كلاس",
                code: """
public class ClassName {
    private String property;
    
    public ClassName(String property) {
        this.property = property;
    }
    
    public void method() {
        // الكود هنا
    }
}
""",
                language: .java,
                category: .classes,
                description: "تعريف كلاس"
            ),
            CodeSnippet(
                title: "For Loop",
                titleAr: "حلقة for",
                code: """
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}
""",
                language: .java,
                category: .loops,
                description: "حلقة for"
            ),
            CodeSnippet(
                title: "ArrayList",
                titleAr: "قائمة",
                code: """
ArrayList<String> list = new ArrayList<>();
list.add("item");
""",
                language: .java,
                category: .dataStructures,
                description: "قائمة ديناميكية"
            ),
        ]
    }
    
    // MARK: - Kotlin Snippets
    
    var kotlinSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Variable",
                titleAr: "متغير",
                code: "var variableName: Type = value",
                language: .kotlin,
                category: .basics,
                description: "تعريف متغير"
            ),
            CodeSnippet(
                title: "Constant",
                titleAr: "ثابت",
                code: "val constantName: Type = value",
                language: .kotlin,
                category: .basics,
                description: "تعريف ثابت"
            ),
            CodeSnippet(
                title: "Function",
                titleAr: "دالة",
                code: """
fun functionName(parameter: Type): ReturnType {
    return value
}
""",
                language: .kotlin,
                category: .functions,
                description: "تعريف دالة"
            ),
            CodeSnippet(
                title: "Data Class",
                titleAr: "كلاس بيانات",
                code: "data class User(val name: String, val age: Int)",
                language: .kotlin,
                category: .classes,
                description: "كلاس بيانات"
            ),
            CodeSnippet(
                title: "Null Safety",
                titleAr: "أمان القيم الفارغة",
                code: "val length = text?.length ?: 0",
                language: .kotlin,
                category: .conditions,
                description: "التعامل مع القيم الفارغة"
            ),
        ]
    }
    
    // MARK: - TypeScript Snippets
    
    var typescriptSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Interface",
                titleAr: "واجهة",
                code: """
interface User {
    name: string;
    age: number;
    email?: string;
}
""",
                language: .typescript,
                category: .classes,
                description: "تعريف واجهة"
            ),
            CodeSnippet(
                title: "Type",
                titleAr: "نوع",
                code: "type Status = \"pending\" | \"approved\" | \"rejected\";",
                language: .typescript,
                category: .basics,
                description: "تعريف نوع مخصص"
            ),
            CodeSnippet(
                title: "Generic Function",
                titleAr: "دالة عامة",
                code: """
function identity<T>(arg: T): T {
    return arg;
}
""",
                language: .typescript,
                category: .functions,
                description: "دالة مع نوع عام"
            ),
        ]
    }
    
    // MARK: - C# Snippets
    
    var csharpSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Main Method",
                titleAr: "الدالة الرئيسية",
                code: """
static void Main(string[] args)
{
    // الكود هنا
}
""",
                language: .csharp,
                category: .basics,
                description: "نقطة بداية البرنامج"
            ),
            CodeSnippet(
                title: "Class",
                titleAr: "كلاس",
                code: """
public class ClassName
{
    public string Property { get; set; }
    
    public void Method()
    {
        // الكود هنا
    }
}
""",
                language: .csharp,
                category: .classes,
                description: "تعريف كلاس"
            ),
            CodeSnippet(
                title: "LINQ Query",
                titleAr: "استعلام LINQ",
                code: "var result = list.Where(x => x > 5).Select(x => x * 2);",
                language: .csharp,
                category: .dataStructures,
                description: "استعلام LINQ"
            ),
        ]
    }
    
    // MARK: - C++ Snippets
    
    var cppSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Hello World",
                titleAr: "مرحبا بالعالم",
                code: """
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
""",
                language: .cpp,
                category: .basics,
                description: "برنامج بسيط"
            ),
            CodeSnippet(
                title: "Class",
                titleAr: "كلاس",
                code: """
class ClassName {
private:
    int property;
    
public:
    ClassName(int p) : property(p) {}
    
    void method() {
        // الكود هنا
    }
};
""",
                language: .cpp,
                category: .classes,
                description: "تعريف كلاس"
            ),
        ]
    }
    
    // MARK: - Go Snippets
    
    var goSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Hello World",
                titleAr: "مرحبا بالعالم",
                code: """
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
""",
                language: .go,
                category: .basics,
                description: "برنامج بسيط"
            ),
            CodeSnippet(
                title: "Function",
                titleAr: "دالة",
                code: """
func functionName(parameter Type) ReturnType {
    return value
}
""",
                language: .go,
                category: .functions,
                description: "تعريف دالة"
            ),
            CodeSnippet(
                title: "Goroutine",
                titleAr: "جوروتين",
                code: """
go func() {
    // الكود هنا
}()
""",
                language: .go,
                category: .async,
                description: "تشغيل كود بشكل متوازي"
            ),
        ]
    }
    
    // MARK: - SQL Snippets
    
    var sqlSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "SELECT",
                titleAr: "استعلام",
                code: "SELECT * FROM table_name WHERE condition;",
                language: .sql,
                category: .database,
                description: "استعلام بيانات"
            ),
            CodeSnippet(
                title: "INSERT",
                titleAr: "إدراج",
                code: "INSERT INTO table_name (column1, column2) VALUES (value1, value2);",
                language: .sql,
                category: .database,
                description: "إدراج بيانات"
            ),
            CodeSnippet(
                title: "UPDATE",
                titleAr: "تحديث",
                code: "UPDATE table_name SET column1 = value1 WHERE condition;",
                language: .sql,
                category: .database,
                description: "تحديث بيانات"
            ),
            CodeSnippet(
                title: "DELETE",
                titleAr: "حذف",
                code: "DELETE FROM table_name WHERE condition;",
                language: .sql,
                category: .database,
                description: "حذف بيانات"
            ),
            CodeSnippet(
                title: "CREATE TABLE",
                titleAr: "إنشاء جدول",
                code: """
CREATE TABLE table_name (
    id INT PRIMARY KEY AUTO_INCREMENT,
    column1 VARCHAR(255) NOT NULL,
    column2 INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
""",
                language: .sql,
                category: .database,
                description: "إنشاء جدول جديد"
            ),
            CodeSnippet(
                title: "JOIN",
                titleAr: "ربط الجداول",
                code: """
SELECT a.*, b.column
FROM table_a a
INNER JOIN table_b b ON a.id = b.a_id
WHERE condition;
""",
                language: .sql,
                category: .database,
                description: "ربط جدولين"
            ),
        ]
    }
    
    // MARK: - HTML Snippets
    
    var htmlSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "HTML Template",
                titleAr: "قالب HTML",
                code: """
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>عنوان الصفحة</title>
</head>
<body>
    <h1>مرحباً</h1>
</body>
</html>
""",
                language: .html,
                category: .basics,
                description: "قالب صفحة HTML"
            ),
            CodeSnippet(
                title: "Form",
                titleAr: "نموذج",
                code: """
<form action="/submit" method="POST">
    <label for="name">الاسم:</label>
    <input type="text" id="name" name="name" required>
    <button type="submit">إرسال</button>
</form>
""",
                language: .html,
                category: .ui,
                description: "نموذج إدخال"
            ),
        ]
    }
    
    // MARK: - CSS Snippets
    
    var cssSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Flexbox Center",
                titleAr: "توسيط Flexbox",
                code: """
.container {
    display: flex;
    justify-content: center;
    align-items: center;
}
""",
                language: .css,
                category: .ui,
                description: "توسيط العناصر"
            ),
            CodeSnippet(
                title: "Grid Layout",
                titleAr: "تخطيط Grid",
                code: """
.grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}
""",
                language: .css,
                category: .ui,
                description: "تخطيط شبكي"
            ),
            CodeSnippet(
                title: "RTL Support",
                titleAr: "دعم RTL",
                code: """
[dir="rtl"] {
    text-align: right;
    direction: rtl;
}
""",
                language: .css,
                category: .ui,
                description: "دعم اللغة العربية"
            ),
        ]
    }
    
    // MARK: - Dart Snippets
    
    var dartSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Main Function",
                titleAr: "الدالة الرئيسية",
                code: """
void main() {
  print('Hello, World!');
}
""",
                language: .dart,
                category: .basics,
                description: "نقطة بداية البرنامج"
            ),
            CodeSnippet(
                title: "Flutter Widget",
                titleAr: "ويدجت Flutter",
                code: """
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello'),
    );
  }
}
""",
                language: .dart,
                category: .ui,
                description: "ويدجت Flutter بسيط"
            ),
        ]
    }
    
    // MARK: - Shell Snippets
    
    var shellSnippets: [CodeSnippet] {
        [
            CodeSnippet(
                title: "Shebang",
                titleAr: "بداية السكريبت",
                code: "#!/bin/bash",
                language: .shell,
                category: .basics,
                description: "بداية سكريبت Bash"
            ),
            CodeSnippet(
                title: "Variable",
                titleAr: "متغير",
                code: """
NAME="value"
echo $NAME
""",
                language: .shell,
                category: .basics,
                description: "تعريف واستخدام متغير"
            ),
            CodeSnippet(
                title: "If Statement",
                titleAr: "جملة if",
                code: """
if [ "$condition" = "true" ]; then
    echo "True"
else
    echo "False"
fi
""",
                language: .shell,
                category: .conditions,
                description: "جملة شرطية"
            ),
            CodeSnippet(
                title: "For Loop",
                titleAr: "حلقة for",
                code: """
for item in list; do
    echo $item
done
""",
                language: .shell,
                category: .loops,
                description: "حلقة for"
            ),
            CodeSnippet(
                title: "Function",
                titleAr: "دالة",
                code: """
function_name() {
    # الكود هنا
    echo "Hello"
}
""",
                language: .shell,
                category: .functions,
                description: "تعريف دالة"
            ),
        ]
    }
}
