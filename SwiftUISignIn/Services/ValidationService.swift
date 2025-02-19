//
//  ValidationService.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

/// This is a utility service for validating user inputs such as email and password.
struct ValidationService {
    
    /// Checks if the provided email is in a valid format.
    /// - Parameter email: The email string to validate.
    /// - Returns: `true` if the email format is valid, otherwise `false`.
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    /// Checks if the password meets the minimum length requirement.
    /// - Parameter password: The password string to validate.
    /// - Returns: `true` if the password is at least 6 characters long, otherwise `false`.
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
