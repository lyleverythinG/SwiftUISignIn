//
//  Login.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var loginViewModel: LoginViewModel
    @ObservedObject private var appViewModel = AppViewModel.shared
    
    init(vm: LoginViewModel = LoginViewModel()) {
        _loginViewModel = StateObject(wrappedValue: vm)
    }
    
    @State private var navigateToRegister = false
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // App Title
                    CustomText.largeTitle("Sign In")
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    EmailTextField(text: $loginViewModel.email, onTextChange: loginViewModel.handleEmailChange)
                    
                    if loginViewModel.hasInteractedWithEmail, let emailErrorMsg = loginViewModel.emailErrorMsg {
                        CustomText.footNote(emailErrorMsg)
                            .foregroundStyle(.red)
                    }
                    
                    Spacer().frame(height: 8)
                    
                    PasswordTextField(text: $loginViewModel.password, onTextChange: loginViewModel.handlePasswordChange)
                    
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
                    }
                }
                .padding()
                .navigationBarHidden(true)
                
                // Loading Indicator Overlay
                if loginViewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
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
            .onChange(of: appViewModel.isUserLoggedIn) {_, isLoggedIn in
                if isLoggedIn {
                    navigateToHome = true
                }
            }
            .fullScreenCover(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}

#Preview {
    LoginView()
}
