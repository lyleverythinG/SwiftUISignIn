//
//  LoadingView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding()
                
                CustomText.body("Please wait...")
                    .foregroundStyle(.white)
                    .padding(.top, 8)
            }
            .padding(20)
            .background(Color(.systemGray5))
            .cornerRadius(12)
        }
    }
}


