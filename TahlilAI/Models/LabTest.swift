//
//  LabTest.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - Test Status Enum
enum TestStatus: String, Codable, CaseIterable {
    case normal = "Normal"
    case high = "Yüksek"
    case low = "Düşük"
    case abnormal = "Anormal"
    
    var displayText: String {
        switch self {
        case .normal:
            return "Normal"
        case .high:
            return "Yüksek"
        case .low:
            return "Düşük"
        case .abnormal:
            return "Anormal"
        }
    }
    
    var color: String {
        switch self {
        case .normal:
            return "systemGreen"
        case .high, .low, .abnormal:
            return "systemRed"
        }
    }
}

// MARK: - Lab Test Model
struct LabTest: Codable {
    let id: String
    let name: String
    let value: String
    let unit: String
    let normalRange: String
    let date: Date
    let category: String
    let testStatus: TestStatus
    
    var isAbnormal: Bool {
        return testStatus != .normal
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         value: String,
         unit: String,
         normalRange: String,
         date: Date = Date(),
         category: String = "Lab Test",
         testStatus: TestStatus = .normal) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.normalRange = normalRange
        self.date = date
        self.category = category
        self.testStatus = testStatus
    }
}

// MARK: - Lab Test Result Model
struct LabTestResult: Codable {
    let date: Date
    let tests: [LabTest]
    let notes: String?
    
    init(date: Date = Date(), tests: [LabTest], notes: String? = nil) {
        self.date = date
        self.tests = tests
        self.notes = notes
    }
} 