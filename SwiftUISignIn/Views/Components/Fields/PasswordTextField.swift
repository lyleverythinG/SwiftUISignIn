//
//  PasswordTextField.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI

struct PasswordTextField: View {
    var title: String = "Password"
    @Binding var text: String
    var onTextChange: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label with asterisk
            HStack(spacing: 0) {
                CustomText.footNote(title)
                    .foregroundStyle(.black)
                
                CustomText.footNote(" *")
                    .foregroundStyle(.red)
            }
            
            // Secure Field
            SecureField(title, text: $text)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: text) { _, newText in
                    onTextChange(newText)
                }
        }
    }
}
