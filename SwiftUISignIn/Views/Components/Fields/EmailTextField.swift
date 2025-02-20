//
//  EmailTextField.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI

struct EmailTextField: View {
    var title: String?
    @Binding var text: String
    var onTextChange: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                CustomText.footNote("Email")
                    .foregroundStyle(.black)
                CustomText.footNote(" *")
                    .foregroundStyle(.red)
            }
            
            TextField(title ?? "Email", text: $text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: text) { _, newValue in
                    onTextChange(newValue)
                }
        }
    }
}
