import Foundation
import Firebase
import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    func saveProfileToFirestore(profile: Profile, completion: @escaping (Error?) -> Void) {
        let profileCodable = profile.toCodable()

        do {
            try db.collection("profiles").document(profile.id.uuidString).setData(from: profileCodable) { error in
                completion(error)
            }
        } catch let error {
            print("Error writing profile to Firestore: \(error)")
            completion(error)
        }
    }

    func fetchProfileFromFirestore(profileId: UUID, completion: @escaping (Profile?) -> Void) {
        let docRef = db.collection("profiles").document(profileId.uuidString)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let profileCodable = try document.data(as: ProfileCodable.self)
                    let profile = Profile(from: profileCodable)
                    completion(profile)
                } catch let error {
                    print("Error decoding profile from Firestore: \(error)")
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
}

