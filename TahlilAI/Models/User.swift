//
//  User.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - User Protocol
protocol UserProtocol: Codable {
    var id: String { get }
    var name: String { get }
    var email: String { get }
    var phone: String? { get }
    var height: Double? { get }
    var weight: Double? { get }
    var age: Int? { get }
    var credits: Int { get }
    var isPremium: Bool { get }
    var theme: String { get }
}

// MARK: - User Model
struct User: UserProtocol {
    let id: String
    let name: String
    let email: String
    let phone: String?
    let height: Double?
    let weight: Double?
    let age: Int?
    let credits: Int
    let isPremium: Bool
    let theme: String
    
    init(id: String = UUID().uuidString,
         name: String,
         email: String,
         phone: String? = nil,
         height: Double? = nil,
         weight: Double? = nil,
         age: Int? = nil,
         credits: Int = 100,
         isPremium: Bool = false,
         theme: String = "system") {
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
