//
//  AuthViewModel.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - Auth ViewModel Protocol
protocol AuthViewModelProtocol: BaseViewModelProtocol {
    var isLoggedIn: Bool { get }
    var onAuthSuccess: (() -> Void)? { get set }
    var onAuthFailure: ((String) -> Void)? { get set }
    
    func login(email: String, password: String)
    func register(name: String, email: String, password: String, confirmPassword: String)
    func logout()
    func validateEmail(_ email: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

// MARK: - Auth ViewModel Implementation
class AuthViewModel: BaseViewModel, AuthViewModelProtocol {
    private let userService: UserServiceProtocol
    
    var isLoggedIn: Bool {
        return userService.getCurrentUser() != nil
    }
    
    var onAuthSuccess: (() -> Void)?
    var onAuthFailure: ((String) -> Void)?
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        super.init()
    }
    
    func login(email: String, password: String) {
        isLoading = true
        
        // Mock login - in real app, this would validate against a backend
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            
            if self.validateEmail(email) && password.count >= 6 {
                // Create mock user for demo
                let user = User(
                    name: "Demo User",
                    email: email,
                    phone: "",
                    height: 175.0,
                    weight: 70.0,
                    age: 30,
                    credits: 10,
                    isPremium: false,
                    theme: .system
                )
                self.userService.saveUser(user)
                self.onAuthSuccess?()
            } else {
                self.onAuthFailure?("Invalid email or password")
            }
        }
    }
    
    func register(name: String, email: String, password: String, confirmPassword: String) {
        isLoading = true
        
        // Validation
        guard !name.isEmpty else {
            isLoading = false
            onAuthFailure?("Name is required")
            return
        }
        
        guard validateEmail(email) else {
            isLoading = false
            onAuthFailure?("Invalid email format")
            return
        }
        
        guard validatePassword(password) else {
            isLoading = false
            onAuthFailure?("Password must be at least 6 characters")
            return
        }
        
        guard password == confirmPassword else {
            isLoading = false
            onAuthFailure?("Passwords do not match")
            return
        }
        
        // Mock registration
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            
            let user = User(
                name: name,
                email: email,
                phone: "",
                height: 0.0,
                weight: 0.0,
                age: 0,
                credits: 10,
                isPremium: false,
                theme: .system
            )
            self.userService.saveUser(user)
            self.onAuthSuccess?()
        }
    }
    
    func logout() {
        userService.deleteUser()
        onDataUpdated?()
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password.count >= 6
    }
} 