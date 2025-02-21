//
//  HomeView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @State private var navigateToLogin = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Welcome Section
                VStack(spacing: 8) {
                    CustomText.title2("Welcome")
                        .fontWeight(.medium)
                    
                    CustomText.largeTitle(userDataViewModel.currentUser?.fullName ?? "Loading...")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .redacted(reason: userDataViewModel.isLoading ? .placeholder : [])
                }
                .padding(.top, 40)
                
                // Email Display
                CustomText.body(userDataViewModel.currentUser?.email ?? "Fetching email...")
                    .foregroundStyle(.gray)
                    .redacted(reason: userDataViewModel.isLoading ? .placeholder : [])
                
                Spacer()
                
                // Sign Out Button
                Button(action: handleSignOut) {
                    CustomText.headLine("Sign Out")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .disabled(userDataViewModel.isLoading)
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $navigateToLogin) {
                ContentView()
            }
            .onAppear {
                // Load user data if not already loaded
                if userDataViewModel.currentUser == nil {
                    guard AuthService.shared.getCurrentUserId != nil else {
                        handleSignOut()
                        return
                    }
                    userDataViewModel.loadUserData()
                }
            }
            .disabled(userDataViewModel.isLoading)
            
            // Loading Overlay
            if userDataViewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        
                        CustomText.body("Loading user data...")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    // MARK: - Sign Out Logic
    private func handleSignOut() {
        let result = AuthService.shared.signOut()
        switch result {
        case .success:
            // Clear all fields.
            userDataViewModel.resetDataToDefault()
            loginViewModel.resetFieldsData()
            registerViewModel.resetFieldsData()
            
            navigateToLogin = true
        case .failure(let error):
            print("Sign-out failed: \(error.localizedDescription)")
        }
    }
}
