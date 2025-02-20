//
//  NameField.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI

struct NameField: View {
    var title: String?
    @Binding var text: String
    var onTextChange: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                CustomText.footNote(title ?? "Name")
                    .foregroundStyle(.black)
                
                CustomText.footNote(" *")
                    .foregroundStyle(.red)
            }
            
            TextField("Full Name", text: $text)
                .autocapitalization(.words)
                .textContentType(.name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: text) { _, newText in
                    onTextChange(newText)
                }
        }
    }
}
