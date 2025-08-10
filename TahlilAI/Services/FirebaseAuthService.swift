//
//  FirebaseAuthService.swift
//  TahlilAI
//
//  Created by Muhammed Yılmaz on 29.07.2025.
//

import Foundation
import FirebaseAuth

// MARK: - Firebase Auth Service Protocol
protocol FirebaseAuthServiceProtocol {
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signOut() -> Bool
    func getCurrentUser() -> User?
    func isUserLoggedIn() -> Bool
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUserProfile(name: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - Firebase Auth Service Implementation
class FirebaseAuthService: FirebaseAuthServiceProtocol {
    private let auth = Auth.auth()
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oluşturulamadı"])))
                return
            }
            
            // Create user profile locally
            let user = User(
                id: firebaseUser.uid,
                name: name,
                email: email,
                credits: 100,
                isPremium: false,
                theme: "system"
            )
            
            completion(.success(user))
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Giriş yapılamadı"])))
                return
            }
            
            // Create user object from Firebase user
            let user = User(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ?? "Kullanıcı",
                email: firebaseUser.email ?? "",
                credits: 100,
                isPremium: false,
                theme: "system"
            )
            
            completion(.success(user))
        }
    }
    
    // MARK: - Sign Out
    func signOut() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Get Current User
    func getCurrentUser() -> User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        
        // For now, return a basic user object
        // In a real app, you'd fetch from Firestore
        return User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "Kullanıcı",
            email: firebaseUser.email ?? "",
            credits: 100,
            isPremium: false,
            theme: "system"
        )
    }
    
    // MARK: - Check if User is Logged In
    func isUserLoggedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Update User Profile
    func updateUserProfile(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let firebaseUser = auth.currentUser else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış"])))
            return
        }
        
        let changeRequest = firebaseUser.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Private Methods
    // Firestore methods removed for now - using local storage only
} 
