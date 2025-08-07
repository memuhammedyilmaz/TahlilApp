//
//  BaseViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation
import UIKit

// MARK: - Base ViewModel Protocol
protocol BaseViewModelProtocol: AnyObject {
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingChanged: ((Bool) -> Void)? { get set }
    
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func clearError()
}

// MARK: - Base ViewModel Implementation
class BaseViewModel: BaseViewModelProtocol {
    
    // MARK: - Properties
    var isLoading: Bool = false {
        didSet {
            onLoadingChanged?(isLoading)
        }
    }
    
    var errorMessage: String? {
        didSet {
            if let error = errorMessage {
                onError?(error)
            }
        }
    }
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    
    // MARK: - Initialization
    init() {
        setupBindings()
    }
    
    // MARK: - Setup Methods
    private func setupBindings() {
        // Override in subclasses if needed
    }
    
    // MARK: - Loading Methods
    func showLoading() {
        isLoading = true
    }
    
    func hideLoading() {
        isLoading = false
    }
    
    // MARK: - Error Methods
    func showError(_ message: String) {
        errorMessage = message
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - Data Methods
    func refreshData() {
        onDataUpdated?()
    }
    
    // MARK: - Utility Methods
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func validateName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Network Methods
    func handleNetworkError(_ error: Error) {
        let nsError = error as NSError
        
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
            showError("İnternet bağlantısı bulunamadı. Lütfen bağlantınızı kontrol edin.")
        case NSURLErrorTimedOut:
            showError("Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.")
        case NSURLErrorCannotFindHost:
            showError("Sunucu bulunamadı. Lütfen daha sonra tekrar deneyin.")
        default:
            showError("Bir hata oluştu. Lütfen tekrar deneyin.")
        }
    }
    
    // MARK: - Lifecycle Methods
    func viewDidLoad() {
        // Override in subclasses
    }
    
    func viewWillAppear() {
        // Override in subclasses
    }
    
    func viewDidAppear() {
        // Override in subclasses
    }
    
    func viewWillDisappear() {
        // Override in subclasses
    }
    
    func viewDidDisappear() {
        // Override in subclasses
    }
    
    // MARK: - Memory Management
    deinit {
        // Cleanup if needed
    }
}
