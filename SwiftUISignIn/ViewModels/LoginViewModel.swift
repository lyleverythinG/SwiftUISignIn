//
//  Untitled.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    //MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var emailErrorMsg: String?
    @Published var passwordErrorMsg: String?
    @Published var hasInteractedWithEmail = false
    @Published var hasInteractedWithPassword = false
    
    /// Returns trimmed email input.
    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Checks if the email format is valid.
    var isEmailValid: Bool {
        ValidationService.isValidEmail(trimmedEmail)
    }
    
    /// Ensures the password meets minimum length requirements.
    var isPasswordValid: Bool {
        ValidationService.isValidPassword(password)
    }
    
    /// Determines if both email and password fields are empty.
    var isEmailAndPasswordEmpty: Bool {
        email.isEmpty && password.isEmpty
    }
    
    /// Validates that both email and password are correctly formatted.
    var isEmailAndPasswordValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    /// Overall form validation, ensuring inputs are not empty and meet requirements.
    var isFormValid: Bool {
        !isEmailAndPasswordEmpty && isEmailAndPasswordValid
    }
    
    /// Handles real-time validation when the user types in the email field.
    func handleEmailChange(_ newText: String) {
        hasInteractedWithEmail = true
        emailErrorMsg = newText.isEmpty ? "Email should not be empty." : (!isEmailValid ? "Please enter a valid email address." : nil)
    }
    
    /// Handles real-time validation when the user types in the password field.
    func handlePasswordChange(_ newText: String) {
        hasInteractedWithPassword = true
        passwordErrorMsg = newText.isEmpty ? "Password is required." : (!isPasswordValid ? "Your password must be at least 6 characters long." : nil)
    }
    
    /// Handles user sign-in with Firebase Authentication and updates session state.
    func signIn() {
        guard isFormValid else {
            errorMessage = email.isEmpty ? "Email should not be empty."
            : password.isEmpty ? "Password should not be empty."
            : !isEmailValid ? "Invalid email format."
            : "Your password must be at least 6 characters long."
            
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.signIn(email: trimmedEmail, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success:
                    print("Successfully logged in!")
                    UIApplication.shared.endEditing()
                    
                    AppViewModel.shared.isUserLoggedIn = true
                    
                    if let userId = AuthService.shared.getCurrentUserId {
                        UserDataViewModel.shared.loadUserData(userId: userId)
                    }
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
}




