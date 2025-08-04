//
//  LabTestService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation
import UIKit

// MARK: - Lab Test Service Protocol
protocol LabTestServiceProtocol {
    func getAllTestResults() -> [LabTestResult]
    func saveTestResult(_ result: LabTestResult)
    func deleteTestResult(_ result: LabTestResult)
    func getTestResultsByDate(_ date: Date) -> [LabTestResult]
    func getTestResultsByCategory(_ category: TestCategory) -> [LabTestResult]
    func analyzeImage(_ image: UIImage, completion: @escaping (Result<[LabTest], Error>) -> Void)
    func getMockTestData() -> [LabTest]
}

// MARK: - Lab Test Service Implementation
class LabTestService: LabTestServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let testResultsKey = "labTestResults"
    
    func getAllTestResults() -> [LabTestResult] {
        guard let data = userDefaults.data(forKey: testResultsKey),
              let results = try? JSONDecoder().decode([LabTestResult].self, from: data) else {
            return []
        }
        return results.sorted { $0.date > $1.date }
    }
    
    func saveTestResult(_ result: LabTestResult) {
        var results = getAllTestResults()
        results.append(result)
        
        if let encoded = try? JSONEncoder().encode(results) {
            userDefaults.set(encoded, forKey: testResultsKey)
        }
    }
    
    func deleteTestResult(_ result: LabTestResult) {
        var results = getAllTestResults()
        results.removeAll { $0.id == result.id }
        
        if let encoded = try? JSONEncoder().encode(results) {
            userDefaults.set(encoded, forKey: testResultsKey)
        }
    }
    
    func getTestResultsByDate(_ date: Date) -> [LabTestResult] {
        let calendar = Calendar.current
        return getAllTestResults().filter { result in
            calendar.isDate(result.date, inSameDayAs: date)
        }
    }
    
    func getTestResultsByCategory(_ category: TestCategory) -> [LabTestResult] {
        return getAllTestResults().filter { result in
            result.tests.contains { $0.category == category }
        }
    }
    
    func analyzeImage(_ image: UIImage, completion: @escaping (Result<[LabTest], Error>) -> Void) {
        // Mock implementation - in real app, this would use AI/ML to analyze the image
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let mockTests = self.getMockTestData()
            completion(.success(mockTests))
        }
    }
    
    func getMockTestData() -> [LabTest] {
        return [
            LabTest(name: "Hemoglobin", value: 14.2, unit: "g/dL", normalRange: 12.0...16.0, category: .blood),
            LabTest(name: "White Blood Cells", value: 7.5, unit: "K/μL", normalRange: 4.5...11.0, category: .blood),
            LabTest(name: "Platelets", value: 250, unit: "K/μL", normalRange: 150...450, category: .blood),
            LabTest(name: "Glucose", value: 95, unit: "mg/dL", normalRange: 70...100, category: .biochemistry),
            LabTest(name: "Creatinine", value: 0.9, unit: "mg/dL", normalRange: 0.6...1.2, category: .biochemistry),
            LabTest(name: "Sodium", value: 140, unit: "mEq/L", normalRange: 135...145, category: .biochemistry),
            LabTest(name: "Potassium", value: 4.0, unit: "mEq/L", normalRange: 3.5...5.0, category: .biochemistry),
            LabTest(name: "Cholesterol", value: 180, unit: "mg/dL", normalRange: 0...200, category: .biochemistry),
            LabTest(name: "Triglycerides", value: 150, unit: "mg/dL", normalRange: 0...150, category: .biochemistry),
            LabTest(name: "pH", value: 6.5, unit: "", normalRange: 4.5...8.0, category: .urine)
        ]
    }
} 