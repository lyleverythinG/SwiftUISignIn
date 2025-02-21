//
//  AuthService.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/18/25.
//

import FirebaseAuth

/// A service responsible for handling Firebase Authentication.
final class AuthService : ObservableObject {
    // MARK: - Published Properties
    @Published var isUserLoggedIn: Bool = false
    
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    /// Initializes the service and starts listening for authentication state changes.
    init() {
        listenForAuthChanges()
    }
    
    /// Retrieves the currently authenticated Firebase user.
    var getCurrentUser: User? {
        return auth.currentUser
    }
    
    /// Retrieves the unique ID of the authenticated user.
    var getCurrentUserId: String? {
        return getCurrentUser?.uid
    }
    
    // MARK: - Authentication Methods
    
    /// Authenticates a user with an email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - completion: A closure returning a `Result` indicating success or failure.
    func signIn(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        
        guard !email.isEmpty else {
            completion(.failure(.emptyEmail))
            return
        }
        guard !password.isEmpty else {
            completion(.failure(.emptyPassword))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(self?.mapFirebaseError(error) ?? .unknown("Unknown error")))
                } else {
                    self?.isUserLoggedIn = true
                    completion(.success(()))
                }
            }
        }
    }
    
    /// Registers a new user with Firebase Authentication.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's chosen password.
    ///   - completion: A closure returning a `Result` indicating success or failure.
    func register(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            completion(.failure(.emptyEmail))
            return
        }
        guard !password.isEmpty else {
            completion(.failure(.emptyPassword))
            return
        }
        
        auth.createUser(withEmail: trimmedEmail, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(self?.mapFirebaseError(error) ?? .unknown("Unknown error")))
                } else {
                    self?.isUserLoggedIn = true
                    completion(.success(()))
                }
            }
        }
    }
    
    /// Logs out the currently authenticated user.
    /// - Returns: A `Result` indicating success or failure.
    func signOut() -> Result<Void, AuthError> {
        do {
            try auth.signOut()
            isUserLoggedIn = false
            return .success(())
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    /// Listens for authentication state changes from Firebase.
    private func listenForAuthChanges() {
        authStateListenerHandle = auth.addStateDidChangeListener { [weak self] _, user in
            self?.isUserLoggedIn = user != nil
        }
    }
    
    /// Checks if a user session already exists
    func checkUserSession() {
        isUserLoggedIn = auth.currentUser != nil
    }
    
    /// Maps Firebase authentication errors to `AuthError` for better error messaging.
    /// - Parameter error: The Firebase authentication error.
    /// - Returns: An `AuthError` corresponding to the Firebase error.
    private func mapFirebaseError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyAttempts
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.operationNotAllowed.rawValue:
            return .operationNotAllowed
        default:
            return .unknown(error.localizedDescription)
        }
    }
}

// MARK: - Authentication Error Enum

/// Defines possible authentication errors in Firebase.
enum AuthError: Error, LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case emailAlreadyInUse
    case userNotFound
    case wrongPassword
    case userDisabled
    case tooManyAttempts
    case networkError
    case weakPassword
    case operationNotAllowed
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Email should not be empty."
        case .emptyPassword:
            return "Password should not be empty."
        case .invalidEmail:
            return "Invalid email format. Please enter a valid email."
        case .emailAlreadyInUse:
            return "This email is already registered. Try logging in."
        case .userNotFound:
            return "No account found for this email. Please check or register a new account."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .userDisabled:
            return "Your account has been disabled. Contact support for assistance."
        case .tooManyAttempts:
            return "Too many login attempts. Please try again later."
        case .networkError:
            return "Network error. Please check your connection and try again."
        case .weakPassword:
            return "Your password is too weak. Use at least 6 characters."
        case .operationNotAllowed:
            return "Email/password sign-in is currently disabled in Firebase."
        case .unknown(let message):
            return message
        }
    }
}
