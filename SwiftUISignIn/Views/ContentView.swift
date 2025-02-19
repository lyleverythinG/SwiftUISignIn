//
//  ContentView.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        if appViewModel.isUserLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
