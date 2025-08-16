//
//  LoginViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation
import FirebaseAuth

// MARK: - Login ViewModel Protocol
protocol LoginViewModelProtocol: AnyObject {
    var onLoginSuccess: (() -> Void)? { get set }
    var onLoginFailure: ((String) -> Void)? { get set }
    
    func login(email: String, password: String)
    func validateEmail(_ email: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

// MARK: - Login ViewModel Implementation
class LoginViewModel: NSObject, LoginViewModelProtocol {
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
        // Validation
        guard !email.isEmpty else {
            onLoginFailure?("E-posta adresi gereklidir")
            return
        }
        
        guard !password.isEmpty else {
            onLoginFailure?("Şifre gereklidir")
            return
        }
        
        guard validateEmail(email) else {
            onLoginFailure?("Geçersiz e-posta formatı")
            return
        }
        
        // Firebase Authentication
        firebaseAuthService.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
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
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
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
