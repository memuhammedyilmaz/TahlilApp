//
//  LabTest.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - Lab Test Protocol
protocol LabTestProtocol {
    var id: String { get }
    var name: String { get }
    var value: Double { get }
    var unit: String { get }
    var normalRange: ClosedRange<Double> { get }
    var date: Date { get }
    var isAbnormal: Bool { get }
    var category: TestCategory { get }
}

// MARK: - Test Category
enum TestCategory: String, CaseIterable, Codable {
    case blood = "blood"
    case urine = "urine"
    case biochemistry = "biochemistry"
    case hematology = "hematology"
    case immunology = "immunology"
    case other = "other"

    var displayName: String {
        switch self {
        case .blood: return "Kan"
        case .urine: return "İdrar"
        case .biochemistry: return "Biyokimya"
        case .hematology: return "Hematoloji"
        case .immunology: return "İmmünoloji"
        case .other: return "Diğer"
        }
    }

    var color: String {
        switch self {
        case .blood: return "#FF6B6B"
        case .urine: return "#4ECDC4"
        case .biochemistry: return "#45B7D1"
        case .hematology: return "#96CEB4"
        case .immunology: return "#FFEAA7"
        case .other: return "#DDA0DD"
        }
    }
}

// MARK: - Lab Test Implementation
struct LabTest: LabTestProtocol, Codable {
    let id: String
    let name: String
    let value: Double
    let unit: String
    let normalRange: ClosedRange<Double>
    let date: Date
    let category: TestCategory

    var isAbnormal: Bool {
        return !normalRange.contains(value)
    }

    init(
        id: String = UUID().uuidString,
        name: String,
        value: Double,
        unit: String,
        normalRange: ClosedRange<Double>,
        date: Date = Date(),
        category: TestCategory
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.normalRange = normalRange
        self.date = date
        self.category = category
    }
}

// MARK: - Lab Test Result
struct LabTestResult: Codable {
    let id: String
    let date: Date
    let tests: [LabTest]
    let imageURL: String?
    let notes: String?

    init(
        id: String = UUID().uuidString,
        date: Date = Date(),
        tests: [LabTest],
        imageURL: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.tests = tests
        self.imageURL = imageURL
        self.notes = notes
    }
} 