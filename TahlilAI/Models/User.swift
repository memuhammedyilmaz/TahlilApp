//
//  User.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - User Protocol
protocol UserProtocol {
    var id: String { get }
    var name: String { get }
    var email: String { get }
    var phone: String { get }
    var height: Double { get }
    var weight: Double { get }
    var age: Int { get }
    var credits: Int { get }
    var isPremium: Bool { get }
    var theme: AppTheme { get }
}

// MARK: - App Theme
enum AppTheme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case system = "system"

    var displayName: String {
        switch self {
        case .light: return "Açık"
        case .dark: return "Koyu"
        case .system: return "Sistem"
        }
    }
}

// MARK: - User Implementation
struct User: UserProtocol, Codable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let height: Double
    let weight: Double
    let age: Int
    let credits: Int
    let isPremium: Bool
    let theme: AppTheme

    init(
        id: String = UUID().uuidString,
        name: String = "",
        email: String = "",
        phone: String = "",
        height: Double = 0.0,
        weight: Double = 0.0,
        age: Int = 0,
        credits: Int = 10,
        isPremium: Bool = false,
        theme: AppTheme = .system
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.height = height
        self.weight = weight
        self.age = age
        self.credits = credits
        self.isPremium = isPremium
        self.theme = theme
    }
} 