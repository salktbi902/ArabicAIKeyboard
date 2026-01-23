// swift-tools-version:5.9
//
//  Package.swift
//  Arabic AI Keyboard
//
//  📦 ملف إدارة التبعيات
//  استخدم هذا الملف إذا كنت تستخدم Swift Package Manager
//

import PackageDescription

let package = Package(
    name: "ArabicAIKeyboard",
    
    platforms: [
        .iOS(.v15)
    ],
    
    products: [
        .library(
            name: "ArabicAIKeyboard",
            targets: ["ArabicAIKeyboard"]
        ),
    ],
    
    dependencies: [
        // KeyboardKit - المكتبة الأساسية للكيبورد
        .package(
            url: "https://github.com/KeyboardKit/KeyboardKit.git",
            from: "9.0.0"
        ),
        
        // Google Generative AI - للذكاء الاصطناعي
        .package(
            url: "https://github.com/google/generative-ai-swift.git",
            from: "0.5.0"
        ),
    ],
    
    targets: [
        .target(
            name: "ArabicAIKeyboard",
            dependencies: [
                "KeyboardKit",
                .product(name: "GoogleGenerativeAI", package: "generative-ai-swift"),
            ],
            path: "Sources"
        ),
    ]
)
