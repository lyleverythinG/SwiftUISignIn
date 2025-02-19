//
//  AppViewModel.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    
    static let shared = AppViewModel()
    
    init() {
        checkUserSession()
    }
    
    /// Checks if a user is currently authenticated.
    func checkUserSession() {
        isUserLoggedIn =  AuthService.shared.getCurrentUser != nil
    }
}
