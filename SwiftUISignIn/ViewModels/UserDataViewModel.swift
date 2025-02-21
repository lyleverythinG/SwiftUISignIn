//
//  UserDataViewModel.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/// ViewModel responsible for managing user-related data and session state.
class UserDataViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentUser: UserModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    // MARK: - Load User Data
    
    /// Loads user data from Firestore after login or registration.
    func loadUserData() {
        guard let userId = AuthService.shared.getCurrentUserId else {
            self.errorMessage = "User ID not found."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        FirestoreService.shared.fetchUserData(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    self.currentUser = UserModel(id: userId, data: data)
                case .failure(let error):
                    self.errorMessage = error.errorDescription
                }
            }
        }
    }
    
    /// This will clear the UserModel after the user signs out.
    func resetDataToDefault() {
        currentUser = nil
    }
    
    // MARK: - Sign Out User
    
    /// Clears the user session when signing out.
    func signOut() {
        let result = AuthService.shared.signOut()
        
        DispatchQueue.main.async {
            switch result {
            case .success:
                print("User successfully signed out.")
                self.currentUser = nil  // Clear user session
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Sign-out failed:", error.localizedDescription)
            }
        }
    }
}
