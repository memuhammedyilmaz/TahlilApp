//
//  UserService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation

// MARK: - User Service Protocol
protocol UserServiceProtocol {
    func getCurrentUser() -> UserProtocol?
    func saveUser(_ user: UserProtocol)
    func updateUser(_ user: UserProtocol)
    func deleteUser()
    func addCredits(_ amount: Int)
    func useCredits(_ amount: Int) -> Bool
    func getAvailableCredits() -> Int
}

// MARK: - User Service Implementation
class UserService: UserServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let userKey = "currentUser"
    
    func getCurrentUser() -> UserProtocol? {
        guard let data = userDefaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func saveUser(_ user: UserProtocol) {
        if let userData = user as? User,
           let encoded = try? JSONEncoder().encode(userData) {
            userDefaults.set(encoded, forKey: userKey)
        }
    }
    
    func updateUser(_ user: UserProtocol) {
        saveUser(user)
    }
    
    func deleteUser() {
        userDefaults.removeObject(forKey: userKey)
    }
    
    func addCredits(_ amount: Int) {
        guard var user = getCurrentUser() as? User else { return }
        let updatedUser = User(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            height: user.height,
            weight: user.weight,
            age: user.age,
            credits: user.credits + amount,
            isPremium: user.isPremium,
            theme: user.theme
        )
        saveUser(updatedUser)
    }
    
    func useCredits(_ amount: Int) -> Bool {
        guard var user = getCurrentUser() as? User else { return false }
        
        if user.credits >= amount {
            let updatedUser = User(
                id: user.id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                height: user.height,
                weight: user.weight,
                age: user.age,
                credits: user.credits - amount,
                isPremium: user.isPremium,
                theme: user.theme
            )
            saveUser(updatedUser)
            return true
        }
        return false
    }
    
    func getAvailableCredits() -> Int {
        return getCurrentUser()?.credits ?? 0
    }
} 