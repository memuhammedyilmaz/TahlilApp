//
//  LoginViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation
import FirebaseAuth

// MARK: - Login ViewModel Protocol
protocol LoginViewModelProtocol: BaseViewModelProtocol {
    var onLoginSuccess: (() -> Void)? { get set }
    var onLoginFailure: ((String) -> Void)? { get set }
    
    func login(email: String, password: String)
    func validateEmail(_ email: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

// MARK: - Login ViewModel Implementation
class LoginViewModel: BaseViewModel, LoginViewModelProtocol {
    private let userService: UserServiceProtocol
    private let firebaseAuthService: FirebaseAuthService
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    init(userService: UserServiceProtocol = UserService(), firebaseAuthService: FirebaseAuthService = FirebaseAuthService()) {
        self.userService = userService
        self.firebaseAuthService = firebaseAuthService
        super.init()
    }
    
    func login(email: String, password: String) {
        showLoading()
        
        // Validation
        guard !email.isEmpty else {
            hideLoading()
            onLoginFailure?("E-posta adresi gereklidir")
            return
        }
        
        guard !password.isEmpty else {
            hideLoading()
            onLoginFailure?("Şifre gereklidir")
            return
        }
        
        guard validateEmail(email) else {
            hideLoading()
            onLoginFailure?("Geçersiz e-posta formatı")
            return
        }
        
        // Firebase Authentication
        firebaseAuthService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoading()
                
                switch result {
                case .success(let user):
                    // Save user to local storage
                    self?.userService.saveUser(user)
                    self?.onLoginSuccess?()
                    
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
        case 17009, 17999: // Wrong password
            errorMessage = "Yanlış şifre"
        case 17008, 17998: // Invalid email
            errorMessage = "Geçersiz e-posta adresi"
        case 17011, 17997: // User not found
            errorMessage = "Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı"
        case 17010, 17996: // Too many requests
            errorMessage = "Çok fazla deneme yaptınız. Lütfen daha sonra tekrar deneyin"
        case 17020, 17995: // Network error
            errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
        case 17005, 17994: // User disabled
            errorMessage = "Hesabınız devre dışı bırakılmış"
        case 17006, 17993: // Operation not allowed
            errorMessage = "E-posta/şifre ile giriş etkin değil"
        default:
            // Debug: Print the actual error for troubleshooting
            print("Firebase Auth Error - Code: \(nsError.code), Description: \(error.localizedDescription)")
            
            // Try to match based on error description as fallback
            let errorDescription = error.localizedDescription.lowercased()
            if errorDescription.contains("password") || errorDescription.contains("şifre") || errorDescription.contains("wrong") {
                errorMessage = "Yanlış şifre"
            } else if errorDescription.contains("email") || errorDescription.contains("e-posta") || errorDescription.contains("invalid") {
                errorMessage = "Geçersiz e-posta adresi"
            } else if errorDescription.contains("user") || errorDescription.contains("kullanıcı") || errorDescription.contains("not found") {
                errorMessage = "Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı"
            } else if errorDescription.contains("network") || errorDescription.contains("ağ") || errorDescription.contains("connection") {
                errorMessage = "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin"
            } else {
                errorMessage = "Giriş yapılırken bir hata oluştu. Lütfen bilgilerinizi kontrol edin."
            }
        }
        
        onLoginFailure?(errorMessage)
    }
}
