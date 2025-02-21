//
//  RegisterView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth


struct RegisterView: View {
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @EnvironmentObject var userDataViewModel: UserDataViewModel
    @State private var navigateToHome = false
    
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                // Title
                CustomText.largeTitle("Create an Account")
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Full Name Field
                NameField(
                    text: $registerViewModel.fullName,
                    onTextChange: registerViewModel.handleFullNameChange
                )
                
                if registerViewModel.hasInteractedWithFullName, let fullNameErrorMsg = registerViewModel.fullNameErrorMsg {
                    CustomText.footNote(fullNameErrorMsg)
                        .foregroundStyle(.red)
                }
                
                // Email Field
                EmailTextField(
                    text: $registerViewModel.email,
                    onTextChange: registerViewModel.handleEmailChange
                )
                
                if registerViewModel.hasInteractedWithEmail, let emailErrorMsg = registerViewModel.emailErrorMsg {
                    CustomText.footNote(emailErrorMsg)
                        .foregroundStyle(.red)
                }
                
                // Password Field
                PasswordTextField(
                    text: $registerViewModel.password,
                    onTextChange: registerViewModel.handlePasswordChange
                )
                
                if registerViewModel.hasInteractedWithPassword, let passwordErrorMsg = registerViewModel.passwordErrorMsg {
                    CustomText.footNote(passwordErrorMsg)
                        .foregroundStyle(.red)
                }
                
                // Register Button
                Button(action: {
                    registerViewModel.register {
                        userDataViewModel.loadUserData()
                    }
                }) {
                    CustomText.headLine("Sign Up")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(registerViewModel.isFormValid ? Color.blue : Color.gray)
                        .opacity(registerViewModel.isFormValid ? 1.0 : 0.5)
                        .cornerRadius(8)
                }
                .disabled(!registerViewModel.isFormValid || registerViewModel.isLoading)
                .padding(.top, 10)
                
                // Error Message (Firebase Errors)
                if let errorMessage = registerViewModel.errorMessage {
                    CustomText.footNote(errorMessage)
                        .foregroundStyle(.red)
                        .padding(.top, 5)
                }
                
                // Back to Login Button
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    CustomText.footNote("Already have an account? Sign In")
                        .foregroundStyle(.blue)
                }
                .padding(.top, 5)
            }
            .padding()
            .navigationBarHidden(true)
            .disabled(registerViewModel.isLoading)
            
            // Loading Indicator Overlay
            if registerViewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        
                        CustomText.body("Creating account...")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        // MARK: - Navigation to HomeView on Successful Registration
        .onChange(of: registerViewModel.isRegistered) { _, isRegistered in
            if isRegistered {
                navigateToHome = true
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeView()
                .environmentObject(userDataViewModel)
        }
    }
}
