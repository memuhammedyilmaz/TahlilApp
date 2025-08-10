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
    
    // MARK: - OCR Text Parsing
    func parseOCRText(_ text: String) -> [LabTest] {
        var tests: [LabTest] = []
        let lines = text.components(separatedBy: .newlines)
        
        print("🔍 OCR Text to parse: \(text)")
        print("📝 Lines count: \(lines.count)")
        
        for (index, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            print("📄 Line \(index): '\(trimmedLine)'")
            
            if !trimmedLine.isEmpty {
                if let test = parseLabTestLine(trimmedLine) {
                    print("✅ Parsed test: \(test.name) = \(test.value) \(test.unit)")
                    tests.append(test)
                } else {
                    print("❌ Could not parse line: '\(trimmedLine)'")
                }
            }
        }
        
        print("🎯 Total parsed tests: \(tests.count)")
        return tests
    }
    
    private func parseLabTestLine(_ line: String) -> LabTest? {
        print("🔍 Parsing lab test line: '\(line)'")
        
        // Remove extra spaces and normalize
        let normalizedLine = line.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // Try to parse as a complete lab test row
        if let test = parseCompleteLabTestRow(normalizedLine) {
            return test
        }
        
        // Try to parse as a test with reference range
        if let test = parseTestWithReference(normalizedLine) {
            return test
        }
        
        // Try to parse as a simple test result
        if let test = parseSimpleTestResult(normalizedLine) {
            return test
        }
        
        return nil
    }
    
    private func parseCompleteLabTestRow(_ line: String) -> LabTest? {
        // Pattern: "Test Name: Value Unit (Reference: Range)" or "Test Name Value Unit Range"
        let patterns = [
            // Pattern 1: "Test: Value Unit (Normal: Range)" or "Test: Value (Eski birim: oldValue oldUnit)"
            #"^(.+?):\s*([\d,\.]+(?:\s*\(Eski birim:\s*[^\)]+\))?)\s*([^\s\(\)]+)?\s*(?:\(Normal:\s*([^\)]+)\)|\(([^\)]+)\)|([\d\-\.,\s]+))?"#,
            // Pattern 2: "Test = Value Unit"
            #"^(.+?)\s*=\s*([\d,\.]+(?:\s*\(Eski birim:\s*[^\)]+\))?)\s*([^\s]+)?"#,
            // Pattern 3: "Test Value Unit ReferenceRange" (most common format)
            #"^(.+?)\s+([\d,\.]+(?:\s*\(Eski birim:\s*[^\)]+\))?)\s+([^\s]+)\s+(.+)$"#,
            // Pattern 4: "Test Value" (simple format)
            #"^(.+?)\s+([\d,\.]+(?:\s*\(Eski birim:\s*[^\)]+\))?)$"#
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(location: 0, length: line.utf16.count)
                if let match = regex.firstMatch(in: line, options: [], range: range) {
                    // Safe range conversion
                    guard let testNameRange = Range(match.range(at: 1), in: line),
                          let valueRange = Range(match.range(at: 2), in: line) else {
                        print("❌ Invalid range conversion")
                        continue
                    }
                    
                    let testName = String(line[testNameRange]).trimmingCharacters(in: .whitespaces)
                    let valueStr = String(line[valueRange]).trimmingCharacters(in: .whitespaces)
                    
                    // Extract unit
                    var unit = ""
                    if match.numberOfRanges > 3 && match.range(at: 3).location != NSNotFound {
                        if let unitRange = Range(match.range(at: 3), in: line) {
                            unit = String(line[unitRange]).trimmingCharacters(in: .whitespaces)
                        }
                    }
                    
                    // Extract reference range
                    var referenceRange = ""
                    if match.numberOfRanges > 4 && match.range(at: 4).location != NSNotFound {
                        if let refRange = Range(match.range(at: 4), in: line) {
                            referenceRange = String(line[refRange]).trimmingCharacters(in: .whitespaces)
                        }
                    } else if match.numberOfRanges > 5 && match.range(at: 5).location != NSNotFound {
                        if let refRange = Range(match.range(at: 5), in: line) {
                            referenceRange = String(line[refRange]).trimmingCharacters(in: .whitespaces)
                        }
                    } else if match.numberOfRanges > 6 && match.range(at: 6).location != NSNotFound {
                        if let refRange = Range(match.range(at: 6), in: line) {
                            referenceRange = String(line[refRange]).trimmingCharacters(in: .whitespaces)
                        }
                    }
                    
                    // Clean up value (remove "Eski birim" info)
                    let cleanValue = cleanTestValue(valueStr)
                    
                    if !cleanValue.isEmpty {
                        let testStatus = determineTestStatus(value: cleanValue, referenceRange: referenceRange)
                        return LabTest(
                            name: testName,
                            value: cleanValue,
                            unit: unit.isEmpty ? "N/A" : unit,
                            normalRange: referenceRange.isEmpty ? "N/A" : referenceRange,
                            testStatus: testStatus
                        )
                    }
                }
            }
        }
        
        return nil
    }
    
    private func parseTestWithReference(_ line: String) -> LabTest? {
        // Pattern: "Test Name Value Unit ReferenceRange"
        let pattern = #"^(.+?)\s+([\d,\.]+)\s+([^\s]+)\s+(.+)$"#
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range) {
                guard match.numberOfRanges > 4,
                      let testNameRange = Range(match.range(at: 1), in: line),
                      let valueRange = Range(match.range(at: 2), in: line),
                      let unitRange = Range(match.range(at: 3), in: line),
                      let referenceRange = Range(match.range(at: 4), in: line) else {
                    return nil
                }
                
                let testName = String(line[testNameRange]).trimmingCharacters(in: .whitespaces)
                let valueStr = String(line[valueRange]).trimmingCharacters(in: .whitespaces)
                let unit = String(line[unitRange]).trimmingCharacters(in: .whitespaces)
                let reference = String(line[referenceRange]).trimmingCharacters(in: .whitespaces)
                
                let cleanValue = cleanTestValue(valueStr)
                
                if !cleanValue.isEmpty {
                    let testStatus = determineTestStatus(value: cleanValue, referenceRange: reference)
                    return LabTest(
                        name: testName,
                        value: cleanValue,
                        unit: unit,
                        normalRange: reference,
                        testStatus: testStatus
                    )
                }
            }
        }
        
        return nil
    }
    
    private func parseSimpleTestResult(_ line: String) -> LabTest? {
        // Pattern: "Test Name Value" (try to extract basic info)
        let pattern = #"^(.+?)\s+([\d,\.]+)"#
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range) {
                guard match.numberOfRanges > 2,
                      let testNameRange = Range(match.range(at: 1), in: line),
                      let valueRange = Range(match.range(at: 2), in: line) else {
                    return nil
                }
                
                let testName = String(line[testNameRange]).trimmingCharacters(in: .whitespaces)
                let valueStr = String(line[valueRange]).trimmingCharacters(in: .whitespaces)
                
                let cleanValue = cleanTestValue(valueStr)
                
                if !cleanValue.isEmpty {
                    return LabTest(
                        name: testName,
                        value: cleanValue,
                        unit: "N/A",
                        normalRange: "N/A",
                        testStatus: .normal
                    )
                }
            }
        }
        
        return nil
    }
    
    private func cleanTestValue(_ value: String) -> String {
        // Remove "Eski birim" information and extract just the numeric value
        if let range = value.range(of: "Eski birim:") {
            let cleanValue = String(value[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
            // Remove any trailing spaces or parentheses
            return cleanValue.replacingOccurrences(of: "\\s*\\(?$", with: "", options: .regularExpression)
        }
        
        // Handle values like "< 1.3" or "> 55"
        if value.hasPrefix("<") || value.hasPrefix(">") || value.hasPrefix(">=") {
            return value.trimmingCharacters(in: .whitespaces)
        }
        
        // Remove any trailing parentheses or extra characters
        let cleanValue = value.replacingOccurrences(of: "\\s*\\(?$", with: "", options: .regularExpression)
        return cleanValue.trimmingCharacters(in: .whitespaces)
    }
    
    private func determineTestStatus(value: String, referenceRange: String) -> TestStatus {
        guard !referenceRange.isEmpty && referenceRange != "N/A" else {
            return .normal
        }
        
        // Handle special cases first
        if value.hasPrefix("<") || value.hasPrefix(">") || value.hasPrefix(">=") {
            // These are already interpreted values, return normal
            return .normal
        }
        
        // Parse reference range
        let cleanRange = referenceRange.replacingOccurrences(of: " ", with: "")
        
        // Handle different reference range formats
        if cleanRange.contains("-") {
            // Range format: "10-20" or "10.0-20.0"
            let components = cleanRange.components(separatedBy: "-")
            if components.count == 2,
               let minValue = Double(components[0]),
               let maxValue = Double(components[1]) {
                if let doubleValue = Double(value) {
                    if doubleValue < minValue {
                        return .low
                    } else if doubleValue > maxValue {
                        return .high
                    } else {
                        return .normal
                    }
                }
            }
        } else if cleanRange.hasPrefix("<") {
            // Less than format: "< 40"
            let valueStr = cleanRange.replacingOccurrences(of: "<", with: "").trimmingCharacters(in: .whitespaces)
            if let maxValue = Double(valueStr) {
                if let doubleValue = Double(value) {
                    return doubleValue > maxValue ? .high : .normal
                }
            }
        } else if cleanRange.hasPrefix(">") {
            // Greater than format: "> 55"
            let valueStr = cleanRange.replacingOccurrences(of: ">", with: "").trimmingCharacters(in: .whitespaces)
            if let minValue = Double(valueStr) {
                if let doubleValue = Double(value) {
                    return doubleValue < minValue ? .low : .normal
                }
            }
        } else if cleanRange.hasPrefix(">=") {
            // Greater than or equal format: ">= 500"
            let valueStr = cleanRange.replacingOccurrences(of: ">=", with: "").trimmingCharacters(in: .whitespaces)
            if let minValue = Double(valueStr) {
                if let doubleValue = Double(value) {
                    return doubleValue < minValue ? .low : .normal
                }
            }
        }
        
        // Handle Turkish reference ranges like "Optimum: <100 mg/dL"
        if cleanRange.contains("Optimum:") || cleanRange.contains("Risk yok:") || cleanRange.contains("Normal:") {
            if let doubleValue = Double(value) {
                // Extract numeric threshold from Turkish text
                let numericPattern = #"(\d+(?:\.\d+)?)"#
                if let regex = try? NSRegularExpression(pattern: numericPattern, options: []) {
                    let range = NSRange(location: 0, length: cleanRange.utf16.count)
                    if let match = regex.firstMatch(in: cleanRange, options: [], range: range) {
                        if match.numberOfRanges > 1,
                           let thresholdRange = Range(match.range(at: 1), in: cleanRange),
                           let threshold = Double(String(cleanRange[thresholdRange])) {
                            if cleanRange.contains("<") {
                                return doubleValue > threshold ? .high : .normal
                            } else if cleanRange.contains(">") {
                                return doubleValue < threshold ? .low : .normal
                            }
                        }
                    }
                }
            }
        }
        
        return .normal
    }
} 
