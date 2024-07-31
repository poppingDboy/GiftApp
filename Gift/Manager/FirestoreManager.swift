import Foundation
import Firebase
import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    // Function to save a profile to Firestore
    func saveProfileToFirestore(profile: ProfileCodable, completion: @escaping (Error?) -> Void) {
        do {
            // Attempt to convert the ProfileCodable instance into Firestore data and save it
            try db.collection("profiles").document(profile.id).setData(from: profile) { error in
                if let error = error {
                    // Log an error if saving the profile to Firestore fails
                    print("Error writing profile to Firestore: \(error.localizedDescription)")
                }
                // Call the completion handler with the error if any
                completion(error)
            }
        } catch let error {
            // Log an error if converting the profile to Firestore data fails
            print("Error converting profile to Firestore data: \(error.localizedDescription)")
            // Call the completion handler with the conversion error
            completion(error)
        }
    }
}
