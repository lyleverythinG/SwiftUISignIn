//
//  ContentView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @ObservedObject private var authService = AuthService.shared
    
    var body: some View {
        Group {
            if authService.isUserLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authService.checkUserSession()
        }
    }
}
