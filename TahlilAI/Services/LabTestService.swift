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
    func clearAllTestResults()
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
    
    func clearAllTestResults() {
        userDefaults.removeObject(forKey: testResultsKey)
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
        results.removeAll { $0.date == result.date }
        
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
            result.tests.contains { $0.category == category.rawValue }
        }
    }
    
    func analyzeImage(_ image: UIImage, completion: @escaping (Result<[LabTest], Error>) -> Void) {
        // TODO: Implement AI/ML image analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.failure(NSError(domain: "LabTestService", code: -1, userInfo: [NSLocalizedDescriptionKey: "AI analysis not implemented yet"])))
        }
    }
} 