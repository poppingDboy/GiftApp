import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol ProfileRepositoryInterface {
    func fetchUserProfile(profileId: String, completion: @escaping (Result<ProfileCodable, Error>) -> Void)
    func disconnect(completion: @escaping (Result<Void, Error>) -> Void)
}

struct UserProfile {
    var emailAddress: String
    var fullname: String
    var phone: String
}

class ProfileRepositoryFirebase: ProfileRepositoryInterface {
    private let db = Firestore.firestore()

    // Function to fetch a user profile from Firestore
    func fetchUserProfile(profileId: String, completion: @escaping (Result<ProfileCodable, Error>) -> Void) {
        // Reference to the specific document in the 'profiles' collection by profile ID
        let profileRef = db.collection("profiles").document(profileId)

        // Retrieve the document with the specified profile ID
        profileRef.getDocument { document, error in
            if let error = error {
                // Return the error if the fetch fails
                completion(.failure(error))
            } else if let document = document, document.exists {
                // Extract data from the document
                let data = document.data() ?? [:]

                // Create a ProfileCodable object from the document data
                let userProfile = ProfileCodable(
                    id: data["id"] as? String ?? "",
                    emailAddress: data["emailAddress"] as? String ?? "",
                    password: data["password"] as? String ?? "",
                    fullName: data["fullName"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? ""
                )

                // Return the user profile on success
                completion(.success(userProfile))
            } else {
                // Return an error if the document does not exist
                completion(.failure(NSError(domain: "ProfileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])))
            }
        }
    }

    // Function to sign out the current user
    func disconnect(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            // Attempt to sign out the user
            try Auth.auth().signOut()
            // Return success if sign out is successful
            completion(.success(()))
        } catch let error {
            // Return an error if sign out fails
            completion(.failure(error))
        }
    }
}

