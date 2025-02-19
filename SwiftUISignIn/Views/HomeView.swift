//
//  HomeView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var userData: UserDataViewModel
    
    init(userDataViewModel: UserDataViewModel = .shared) {
        self.userData = userDataViewModel
    }
    
    @State private var navigateToLogin = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                VStack(spacing: 8) {
                    // Welcome Header
                    CustomText.title2("Welcome,")
                        .fontWeight(.medium)
                    
                    // Full Name
                    CustomText.largeTitle(userData.currentUser?.fullName ?? "")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .redacted(reason: userData.isLoading ? .placeholder : [])
                }
                .padding(.top, 40)
                
                // Email Display
                CustomText.body(userData.currentUser?.email ?? "")
                    .foregroundStyle(.gray)
                    .redacted(reason: userData.isLoading ? .placeholder : [])
                
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
                .disabled(userData.isLoading)
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $navigateToLogin) {
                ContentView()
            }
            .onAppear {
                if userData.currentUser == nil {
                    userData.loadUserData(userId: AuthService.shared.getCurrentUserId ?? "")
                }
            }
            .disabled(userData.isLoading)
            
            // Loading Indicator Overlay
            if userData.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
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
    
    /// Triggers the sign out functionality.
    private func handleSignOut() {
        userData.signOut()
        navigateToLogin = true
    }
}

#Preview {
    HomeView()
}
