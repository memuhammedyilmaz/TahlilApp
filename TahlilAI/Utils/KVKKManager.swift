//
//  KVKKManager.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

class KVKKManager {
    
    static let shared = KVKKManager()
    
    private init() {}
    
    // MARK: - KVKK Consent Check
    func hasUserConsented() -> Bool {
        return UserDefaults.standard.bool(forKey: "KVKKConsent")
    }
    
    func getConsentDate() -> Date? {
        return UserDefaults.standard.object(forKey: "KVKKConsentDate") as? Date
    }
    
    func saveConsent() {
        UserDefaults.standard.set(true, forKey: "KVKKConsent")
        UserDefaults.standard.set(Date(), forKey: "KVKKConsentDate")
    }
    
    func revokeConsent() {
        UserDefaults.standard.removeObject(forKey: "KVKKConsent")
        UserDefaults.standard.removeObject(forKey: "KVKKConsentDate")
    }
    
    // MARK: - Consent Status
    func getConsentStatus() -> KVKKConsentStatus {
        if hasUserConsented() {
            if let consentDate = getConsentDate() {
                return .consented(date: consentDate)
            } else {
                return .consented(date: Date())
            }
        } else {
            return .notConsented
        }
    }
    
    // MARK: - Consent Validation
    func isConsentValid() -> Bool {
        guard hasUserConsented(), let consentDate = getConsentDate() else {
            return false
        }
        
        // Check if consent is older than 1 year (optional validation)
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        return consentDate > oneYearAgo
    }
    
    // MARK: - Data Deletion
    func deleteUserData() {
        // Clear all user data
        UserDefaults.standard.removeObject(forKey: "KVKKConsent")
        UserDefaults.standard.removeObject(forKey: "KVKKConsentDate")
        
        // Clear other user data (add more as needed)
        UserDefaults.standard.removeObject(forKey: "userProfile")
        UserDefaults.standard.removeObject(forKey: "labTestHistory")
        UserDefaults.standard.removeObject(forKey: "userPreferences")
        
        // Clear lab test results
        let labTestService = LabTestService.shared
        // TODO: Implement clearAllTestResults method
        
        // Clear Firebase user data (if needed)
        // This should be handled in your Firebase service
    }
}

// MARK: - KVKK Consent Status Enum
enum KVKKConsentStatus {
    case notConsented
    case consented(date: Date)
    
    var description: String {
        switch self {
        case .notConsented:
            return "KVKK izni verilmemiş"
        case .consented(let date):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return "KVKK izni verildi: \(formatter.string(from: date))"
        }
    }
}
