//
//  AnalysisResultManager.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 8.08.2025.
//

import Foundation

class AnalysisResultManager {
    
    // MARK: - Singleton
    static let shared = AnalysisResultManager()
    
    // MARK: - Constants
    private let userDefaultsKey = "AnalysisResults"
    private let maxResults = 100 // Maximum number of results to store
    
    // MARK: - Private Initializer
    private init() {}
    
    // MARK: - Public Methods
    
    /// Saves an analysis result
    func saveAnalysisResult(_ result: AnalysisResult) {
        var results = getAllAnalysisResults()
        
        // Remove existing result with same ID if exists
        results.removeAll { $0.id == result.id }
        
        // Add new result at the beginning
        results.insert(result, at: 0)
        
        // Limit the number of results
        if results.count > maxResults {
            results = Array(results.prefix(maxResults))
        }
        
        saveToUserDefaults(results)
    }
    
    /// Gets all analysis results
    func getAllAnalysisResults() -> [AnalysisResult] {
        return loadFromUserDefaults()
    }
    
    /// Gets analysis results by type
    func getAnalysisResults(by type: AnalysisType) -> [AnalysisResult] {
        return getAllAnalysisResults().filter { $0.analysisType == type }
    }
    
    /// Gets a specific analysis result by ID
    func getAnalysisResult(by id: String) -> AnalysisResult? {
        return getAllAnalysisResults().first { $0.id == id }
    }
    
    /// Deletes an analysis result
    func deleteAnalysisResult(_ result: AnalysisResult) {
        var results = getAllAnalysisResults()
        results.removeAll { $0.id == result.id }
        saveToUserDefaults(results)
    }
    
    /// Deletes all analysis results
    func deleteAllAnalysisResults() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    /// Gets the total count of analysis results
    func getTotalCount() -> Int {
        return getAllAnalysisResults().count
    }
    
    /// Gets the count by analysis type
    func getCount(by type: AnalysisType) -> Int {
        return getAnalysisResults(by: type).count
    }
    
    /// Gets recent analysis results (last N results)
    func getRecentResults(limit: Int = 10) -> [AnalysisResult] {
        let results = getAllAnalysisResults()
        return Array(results.prefix(limit))
    }
    
    /// Searches analysis results by title or content
    func searchAnalysisResults(query: String) -> [AnalysisResult] {
        let results = getAllAnalysisResults()
        let lowercasedQuery = query.lowercased()
        
        return results.filter { result in
            result.title.lowercased().contains(lowercasedQuery) ||
            result.analysisText.lowercased().contains(lowercasedQuery)
        }
    }
    
    /// Gets analysis results within a date range
    func getAnalysisResults(from startDate: Date, to endDate: Date) -> [AnalysisResult] {
        return getAllAnalysisResults().filter { result in
            result.analysisDate >= startDate && result.analysisDate <= endDate
        }
    }
    
    /// Gets analysis statistics
    func getAnalysisStatistics() -> AnalysisStatistics {
        let results = getAllAnalysisResults()
        
        let totalCount = results.count
        let imageCount = results.filter { $0.analysisType == .image }.count
        let pdfCount = results.filter { $0.analysisType == .pdf }.count
        
        let totalProcessingTime = results.compactMap { $0.metadata.processingTime }.reduce(0, +)
        let averageProcessingTime = totalCount > 0 ? totalProcessingTime / Double(totalCount) : 0
        
        let totalTextLength = results.compactMap { $0.metadata.textLength }.reduce(0, +)
        let averageTextLength = totalCount > 0 ? totalTextLength / totalCount : 0
        
        return AnalysisStatistics(
            totalCount: totalCount,
            imageCount: imageCount,
            pdfCount: pdfCount,
            averageProcessingTime: averageProcessingTime,
            averageTextLength: averageTextLength,
            lastAnalysisDate: results.first?.analysisDate
        )
    }
    
    // MARK: - Private Methods
    
    private func saveToUserDefaults(_ results: [AnalysisResult]) {
        do {
            let data = try JSONEncoder().encode(results)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            // Error saving analysis results
        }
    }
    
    private func loadFromUserDefaults() -> [AnalysisResult] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return []
        }
        
        do {
            let results = try JSONDecoder().decode([AnalysisResult].self, from: data)
            return results
        } catch {
            // Error loading analysis results
            return []
        }
    }
}

// MARK: - Analysis Statistics Model
struct AnalysisStatistics {
    let totalCount: Int
    let imageCount: Int
    let pdfCount: Int
    let averageProcessingTime: Double
    let averageTextLength: Int
    let lastAnalysisDate: Date?
    
    var imagePercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(imageCount) / Double(totalCount) * 100
    }
    
    var pdfPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(pdfCount) / Double(totalCount) * 100
    }
    
    var formattedAverageProcessingTime: String {
        let seconds = Int(averageProcessingTime)
        if seconds < 60 {
            return "\(seconds) saniye"
        } else {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return "\(minutes) dakika \(remainingSeconds) saniye"
        }
    }
    
    var formattedLastAnalysisDate: String {
        guard let date = lastAnalysisDate else { return "Hiç analiz yapılmamış" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

