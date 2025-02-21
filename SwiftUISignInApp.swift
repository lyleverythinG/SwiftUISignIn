//
//  SwiftUISignInApp.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import SwiftUI
import Firebase

@main
struct SwiftUISignInApp: App {
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var registerViewModel = RegisterViewModel()
    @StateObject var userDataViewModel = UserDataViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .environmentObject(registerViewModel)
                .environmentObject(userDataViewModel)
        }
    }
}
