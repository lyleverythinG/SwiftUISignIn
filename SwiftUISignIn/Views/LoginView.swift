//
//  Login.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    
    @State private var navigateToRegister = false
    @State private var navigateToHome = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // App Title
                    CustomText.largeTitle("Sign In")
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    // Email Input
                    EmailTextField(
                        text: $loginViewModel.email,
                        onTextChange: loginViewModel.handleEmailChange
                    )
                    
                    if loginViewModel.hasInteractedWithEmail, let emailErrorMsg = loginViewModel.emailErrorMsg {
                        CustomText.footNote(emailErrorMsg)
                            .foregroundStyle(.red)
                    }
                    
                    Spacer().frame(height: 8)
                    
                    // Password Input
                    PasswordTextField(
                        text: $loginViewModel.password,
                        onTextChange: loginViewModel.handlePasswordChange
                    )
                    
                    if loginViewModel.hasInteractedWithPassword, let passwordErrorMsg = loginViewModel.passwordErrorMsg {
                        CustomText.footNote(passwordErrorMsg)
                            .foregroundStyle(.red)
                    }
                    
                    // Sign In Button
                    Button(action: loginViewModel.signIn) {
                        CustomText.headLine("Login")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(loginViewModel.isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!loginViewModel.isFormValid || loginViewModel.isLoading)
                    .padding(.top, 10)
                    
                    // Error Message
                    if let errorMessage = loginViewModel.errorMessage {
                        CustomText.footNote(errorMessage)
                            .foregroundStyle(.red)
                            .padding(.top, 5)
                    }
                    
                    // Divider
                    Divider().padding(.vertical)
                    
                    // Route to RegisterView
                    Button(action: {
                        navigateToRegister = true
                    }) {
                        CustomText.footNote("Don't have an account? Sign Up")
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, 5)
                    .navigationDestination(isPresented: $navigateToRegister) {
                        RegisterView()
                            .onAppear {
                                UIApplication.shared.endEditing()
                            }
                    }
                }
                .padding()
                .navigationBarHidden(true)
                
                // Loading Indicator Overlay
                if loginViewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        
                        VStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                            
                            CustomText.body("Signing in...")
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            // MARK: - Handle Navigation
            .onChange(of: loginViewModel.isLoginSuccessful) { _, isLoggedIn in
                if isLoggedIn {
                    userDataViewModel.loadUserData()
                    navigateToHome = true
                }
            }
            .fullScreenCover(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}
