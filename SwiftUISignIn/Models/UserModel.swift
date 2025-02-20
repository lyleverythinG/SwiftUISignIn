//
//  UserModle.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//
import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    let createdAt: Date?
    
    // Convert Firestore dictionary to UserModel
    init(id: String, data: [String: Any]) {
        self.id = id
        self.fullName = data["fullName"] as? String ?? "Unknown"
        self.email = data["email"] as? String ?? "Unknown"
        
        
        if let timestamp = data["createdAt"] as? Double {
            self.createdAt = Date(timeIntervalSince1970: timestamp)
        } else {
            self.createdAt = nil
        }
    }
}

