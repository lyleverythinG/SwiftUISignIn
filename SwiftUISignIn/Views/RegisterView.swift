//
//  RegisterView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @StateObject private var vm: RegisterViewModel
    @State private var navigateToHome = false
    
    
    init(vm: RegisterViewModel = RegisterViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                // Title
                CustomText.largeTitle("Create an Account")
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Full Name Field
                NameField(text: $vm.fullName, onTextChange: vm.handleFullNameChange)
                
                if vm.hasInteractedWithFullName, let fullNameErrorMsg = vm.fullNameErrorMsg {
                    CustomText.footNote(fullNameErrorMsg)
                        .foregroundStyle(.red)
                }
                
                // Email Field
                EmailTextField(text: $vm.email, onTextChange: vm.handleEmailChange)
                
                if vm.hasInteractedWithEmail, let emailErrorMsg = vm.emailErrorMsg {
                    CustomText.footNote(emailErrorMsg)
                        .foregroundStyle(.red)
                }
                
                // Password Field
                PasswordTextField(text: $vm.password, onTextChange: vm.handlePasswordChange)
                
                if vm.hasInteractedWithPassword, let passwordErrorMsg = vm.passwordErrorMsg {
                    CustomText.footNote(passwordErrorMsg)
                        .foregroundStyle(.red)
                }
                
                // Register Button
                Button(action: {
                    vm.register()
                }) {
                    CustomText.headLine("Sign Up")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.isFormValid ? Color.blue : Color.gray)
                        .opacity(vm.isFormValid ? 1.0 : 0.5)
                        .cornerRadius(8)
                }
                .disabled(!vm.isFormValid || vm.isLoading)
                .padding(.top, 10)
                
                // Error Message (Firebase Errors)
                if let errorMessage = vm.errorMessage {
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
            .disabled(vm.isLoading) // Disable interactions when loading
            
            // Loading Indicator Overlay
            if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
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
        .onChange(of: vm.isRegistered) {_, isRegistered in
            if isRegistered {
                navigateToHome = true
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeView()
        }
    }
}

#Preview {
    RegisterView()
}
