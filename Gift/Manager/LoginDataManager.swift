import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics

protocol LoginRepositoryInterface {
    func signIn(withEmail: String, password: String, loggedAction: @escaping (Result<Void,Error>) -> Void)
}

class LoginRepositoryFirebase: LoginRepositoryInterface {
    let db = Firestore.firestore()
    lazy var profilesCollection = db.collection("profiles")

    // Function to handle user sign-in with email and password
    func signIn(withEmail: String, password: String, loggedAction: @escaping (Result<Void, Error>) -> Void) {
        // Attempt to authenticate the user with Firebase Auth using the provided email and password
        Auth.auth().signIn(withEmail: withEmail, password: password) { [weak self] authResult, error in
            if let error = error {
                // If authentication fails, log an event for failed authentication in Firebase Analytics
                Analytics.logEvent("authentication_failed", parameters: [
                    "email": withEmail
                ])
                // Return the error through the completion handler
                loggedAction(.failure(error))
            } else if let _ = authResult?.user {
                // If authentication is successful, log an event for successful authentication in Firebase Analytics
                Analytics.logEvent("authentication_success", parameters: [
                    "email": withEmail
                ])
                // Return success through the completion handler
                loggedAction(.success(()))
            } else {
                // Handle any other cases that don't fit the success or failure scenarios
                let unknownError = NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown authentication error."])
                // Return the unknown error through the completion handler
                loggedAction(.failure(unknownError))
            }
        }
    }
}

