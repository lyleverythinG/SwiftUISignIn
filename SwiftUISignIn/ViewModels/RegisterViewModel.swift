//
//  RegisterViewModeel.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    //MARK: - Published Properties
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasInteractedWithFullName = false
    @Published var hasInteractedWithEmail = false
    @Published var hasInteractedWithPassword = false
    @Published var fullNameErrorMsg: String?
    @Published var emailErrorMsg: String?
    @Published var passwordErrorMsg: String?
    @Published var isRegistered = false
    
    /// Returns trimmed email input.
    var isFullNameValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Checks if the email format is valid.
    var isEmailValid: Bool {
        ValidationService.isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    /// Ensures the password meets minimum length requirements.
    var isPasswordValid: Bool {
        ValidationService.isValidPassword(password)
    }
    
    /// Validates that all form fields are correctly filled.
    var isFormValid: Bool {
        isFullNameValid && isEmailValid && isPasswordValid
    }
    
    /// Handles validation when the user types in the full name field
    func handleFullNameChange(_ newText: String) {
        hasInteractedWithFullName = true
        fullNameErrorMsg = newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Full name should not be empty" : nil
    }
    
    /// Handles validation when the user types in the email field
    func handleEmailChange(_ newText: String) {
        hasInteractedWithEmail = true
        emailErrorMsg = newText.isEmpty ? "Email should not be empty" : (!isEmailValid ? "Please enter a valid email address." : nil)
    }
    
    /// Handles validation when the user types in the password field
    func handlePasswordChange(_ newText: String) {
        hasInteractedWithPassword = true
        passwordErrorMsg = newText.isEmpty ? "Password is required." : (!isPasswordValid ? "Your password must be at least 6 characters." : nil)
    }
    
    
    /// Handles user registration with Firebase Authentication and saves user data to Firestore.
    func register(completion: (() -> Void)? = nil) {
        guard isFormValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.register(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    print("Account created successfully!")
                    
                    // Dismiss keyboard after successful registration.
                    UIApplication.shared.endEditing()
                    
                    guard let userId = AuthService.shared.getCurrentUserId else {
                        self.errorMessage = "Failed to retrieve user ID after registration."
                        return
                    }
                    
                    // Save user data to Firestore.
                    self.saveUserToFirestore(userId: userId, fullName: self.fullName, email: self.email, completion: completion)
                    
                    self.isRegistered = true
                    
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
    
    /// Saves authenticated user details to Firestore and updates the local user data.
    private func saveUserToFirestore(userId: String, fullName: String, email: String, completion: (() -> Void)?) {
        FirestoreService.shared.saveUserData(userId: userId, fullName: fullName, email: email) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("User data saved to Firestore!")
                    
                    // Load userData
                    UserDataViewModel.shared.loadUserData(userId: userId)
                    
                    completion?()
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
