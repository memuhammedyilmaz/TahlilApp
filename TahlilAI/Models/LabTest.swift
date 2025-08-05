//
//  LabTest.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - Lab Test Model
struct LabTest: Codable {
    let id: String
    let name: String
    let value: Double
    let unit: String
    let normalRange: String
    let date: Date
    let category: String
    
    var isAbnormal: Bool {
        // Simple logic to determine if test is abnormal
        // In a real app, you'd parse the normalRange string and compare
        let rangeComponents = normalRange.components(separatedBy: "-")
        if rangeComponents.count == 2,
           let minValue = Double(rangeComponents[0].trimmingCharacters(in: .whitespaces)),
           let maxValue = Double(rangeComponents[1].trimmingCharacters(in: .whitespaces)) {
            return value < minValue || value > maxValue
        }
        return false
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         value: Double,
         unit: String,
         normalRange: String,
         date: Date = Date(),
         category: String) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.normalRange = normalRange
        self.date = date
        self.category = category
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