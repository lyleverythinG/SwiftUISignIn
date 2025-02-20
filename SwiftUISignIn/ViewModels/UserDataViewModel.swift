//
//  UserDataViewModel.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class UserDataViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    static let shared = UserDataViewModel()
    private let db = Firestore.firestore()
    
    private init() {}
    
    /// Loads user data from Firestore after login or registration
    func loadUserData(userId: String) {
        isLoading = true
        errorMessage = nil
        
        db.collection(FirestoreConstants.users).document(userId).getDocument { document, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let document = document, document.exists, let data = document.data() {
                    self.currentUser = UserModel(id: userId, data: data)
                } else {
                    self.errorMessage = "User data not found."
                }
            }
        }
    }
    
    /// Clears the user session when signing out
    func signOut() {
        let result = AuthService.shared.signOut()
        
        DispatchQueue.main.async {
            switch result {
            case .success:
                print("User successfully signed out.")
                self.currentUser = nil  // Clear user session
                AppViewModel.shared.checkUserSession()
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Sign-out failed:", error.localizedDescription)
            }
        }
    }
}
