//
//  RegisterViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation
import FirebaseAuth

// MARK: - Register ViewModel Protocol
protocol RegisterViewModelProtocol: BaseViewModelProtocol {
    var onRegisterSuccess: (() -> Void)? { get set }
    var onRegisterFailure: ((String) -> Void)? { get set }
    
    func register(name: String, email: String, password: String, confirmPassword: String)
    func validateEmail(_ email: String) -> Bool
    func validatePassword(_ password: String) -> Bool
    func validateName(_ name: String) -> Bool
}

// MARK: - Register ViewModel Implementation
class RegisterViewModel: BaseViewModel, RegisterViewModelProtocol {
    private let userService: UserServiceProtocol
    private let firebaseAuthService: FirebaseAuthService
    
    var onRegisterSuccess: (() -> Void)?
    var onRegisterFailure: ((String) -> Void)?
    
    init(userService: UserServiceProtocol = UserService(), firebaseAuthService: FirebaseAuthService = FirebaseAuthService()) {
        self.userService = userService
        self.firebaseAuthService = firebaseAuthService
        super.init()
    }
    
    func register(name: String, email: String, password: String, confirmPassword: String) {
        showLoading()
        
        // Validation
        guard validateName(name) else {
            hideLoading()
            onRegisterFailure?("Ad soyad gereklidir")
            return
        }
        
        guard validateEmail(email) else {
            hideLoading()
            onRegisterFailure?("Geçersiz e-posta formatı")
            return
        }
        
        guard validatePassword(password) else {
            hideLoading()
            onRegisterFailure?("Şifre en az 6 karakter olmalıdır")
            return
        }
        
        guard password == confirmPassword else {
            hideLoading()
            onRegisterFailure?("Şifreler eşleşmiyor")
            return
        }
        
        // Firebase Authentication
        firebaseAuthService.signUp(email: email, password: password, name: name) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()
                
                switch result {
                case .success(let user):
                    // Save user to local storage
                    self?.userService.saveUser(user)
                    self?.onRegisterSuccess?()
                    
                case .failure(let error):
                    self?.handleAuthError(error)
                }
            }
        }
    }
    
    // Validation methods are now inherited from BaseViewModel
    
    // MARK: - Error Handling
    private func handleAuthError(_ error: Error) {
        let errorMessage: String
        let nsError = error as NSError
        
        // Firebase Auth error codes
        switch nsError.code {
        case 17008: // Invalid email
            errorMessage = "Geçersiz e-posta adresi"
        case 17026: // Weak password
            errorMessage = "Şifre çok zayıf. En az 6 karakter kullanın"
        case 17007: // Email already in use
            errorMessage = "Bu e-posta adresi zaten kullanımda"
        case 17010: // Too many requests
            errorMessage = "Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin"
        case 17020: // Network error
            errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
        case 17006: // Operation not allowed
            errorMessage = "E-posta/şifre ile kayıt etkin değil"
        default:
           
            
            // Try to match based on error description as fallback
            let errorDescription = error.localizedDescription.lowercased()
            if errorDescription.contains("email") || errorDescription.contains("e-posta") || errorDescription.contains("invalid") {
                errorMessage = "Geçersiz e-posta adresi"
            } else if errorDescription.contains("password") || errorDescription.contains("şifre") || errorDescription.contains("weak") {
                errorMessage = "Şifre çok zayıf. En az 6 karakter kullanın"
            } else if errorDescription.contains("already") || errorDescription.contains("zaten") || errorDescription.contains("in use") {
                errorMessage = "Bu e-posta adresi zaten kullanımda"
            } else if errorDescription.contains("network") || errorDescription.contains("ağ") || errorDescription.contains("connection") {
                errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
            } else {
                errorMessage = "Hesap oluşturulurken bir hata oluştu. Lütfen bilgilerinizi kontrol edin."
            }
        }
        
        onRegisterFailure?(errorMessage)
    }
}
