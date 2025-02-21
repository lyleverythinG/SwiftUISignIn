//
//  FirestoreService.swift
//  SwiftUISignIn
//
//  Created by Lyle Dane Carcedo on 2/19/25.
//
import FirebaseFirestore


/// A service responsible for handling Firestore operations.
final class FirestoreService {
    
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    
    /// Saves user data to Firestore upon successful registration.
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    ///   - fullName: The user's full name.
    ///   - email: The user's email address.
    ///   - completion: A closure returning a `Result` indicating success or failure.
    func saveUserData(
        userId: String,
        fullName: String,
        email: String,
        completion: @escaping (Result<Void, FirestoreError>) -> Void
    ) {
        let userData: [String: Any] = [
            "fullName": fullName,
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection(FirestoreConstants.users)
            .document(userId)
            .setData(userData) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(self.mapFirestoreError(error)))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
    
    /// Fetches user data from Firestore.
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    ///   - completion: A closure returning a `Result` with user data or failure.
    func fetchUserData(
        userId: String,
        completion: @escaping (Result<[String: Any], FirestoreError>) -> Void
    ) {
        db.collection(FirestoreConstants.users)
            .document(userId)
            .getDocument { document, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(self.mapFirestoreError(error)))
                    } else if let document = document, document.exists {
                        completion(.success(document.data() ?? [:]))
                    } else {
                        completion(.failure(.documentNotFound))
                    }
                }
            }
    }
    
    /// Deletes a user document from Firestore.
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    ///   - completion: A closure returning a `Result` indicating success or failure.
    func deleteUserData(
        userId: String,
        completion: @escaping (Result<Void, FirestoreError>) -> Void
    ) {
        db.collection(FirestoreConstants.users)
            .document(userId)
            .delete { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(self.mapFirestoreError(error)))
                    } else {
                        completion(.success(()))
                    }
                }
            }
    }
    
    /// Maps Firestore errors to `FirestoreError` for better error messaging.
    /// - Parameter error: The Firestore operation error.
    /// - Returns: A `FirestoreError` corresponding to the Firestore error.
    private func mapFirestoreError(_ error: Error) -> FirestoreError {
        let nsError = error as NSError
        
        switch nsError.code {
        case FirestoreErrorCode.permissionDenied.rawValue:
            return .permissionDenied
        case FirestoreErrorCode.unavailable.rawValue:
            return .serviceUnavailable
        case FirestoreErrorCode.notFound.rawValue:
            return .documentNotFound
        default:
            return .unknown(error.localizedDescription)
        }
    }
}

// MARK: - Firestore Error Enum

/// Custom error enum for Firestore errors.
enum FirestoreError: Error, LocalizedError {
    case permissionDenied
    case serviceUnavailable
    case documentNotFound
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "You don't have permission to access Firestore."
        case .serviceUnavailable:
            return "Firestore service is currently unavailable. Please try again later."
        case .documentNotFound:
            return "Requested document not found."
        case .unknown(let message):
            return message
        }
    }
}
