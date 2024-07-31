import Foundation
import Firebase
import FirebaseFirestore

protocol AccountRepositoryInterface {
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void)
}

class AccountRepositoryFirebase: AccountRepositoryInterface {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()

    // Function to sign up a new user with the provided email and password
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        // Create a new user with Firebase Authentication
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Return the error through the completion handler if registration fails
                completion(error)
                return
            }

            guard let user = authResult?.user else {
                // Return an error if the user object is nil
                let unknownError = NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])
                completion(unknownError)
                return
            }

            // Prepare user profile data to be saved in Firestore
            let profileData: [String: Any] = [
                "emailAddress": email,
                "fullName": "",
                "phoneNumber": ""
            ]

            // Save the user's profile data to Firestore
            self.db.collection("profiles").document(user.uid).setData(profileData) { error in
                if let error = error {
                    // Return the error through the completion handler if saving profile data fails
                    completion(error)
                } else {
                    // No error occurred, indicate success
                    completion(nil)
                }
            }
        }
    }
}

