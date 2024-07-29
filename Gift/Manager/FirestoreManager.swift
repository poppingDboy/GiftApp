import Foundation
import Firebase
import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    func saveProfileToFirestore(profile: ProfileCodable, completion: @escaping (Error?) -> Void) {
        do {
            try db.collection("profiles").document(profile.id.uuidString).setData(from: profile) { error in
                if let error = error {
                    print("Error writing profile to Firestore: \(error.localizedDescription)")
                }
                completion(error)
            }
        } catch let error {
            print("Error converting profile to Firestore data: \(error.localizedDescription)")
            completion(error)
        }
    }

    func fetchProfileFromFirestore(profileId: UUID, completion: @escaping (ProfileCodable?) -> Void) {
        let docRef = db.collection("profiles").document(profileId.uuidString)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let profileCodable = try document.data(as: ProfileCodable.self)
                    completion(profileCodable)
                } catch let error {
                    print("Error decoding profile from Firestore: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                if let error = error {
                    print("Error fetching profile from Firestore: \(error.localizedDescription)")
                } else {
                    print("Profile does not exist in Firestore")
                }
                completion(nil)
            }
        }
    }
}










//import Foundation
//import Firebase
//import FirebaseFirestore
//
//class FirestoreManager {
//    private let db = Firestore.firestore()
//
//    func saveProfileToFirestore(profile: ProfileCodable, completion: @escaping (Error?) -> Void) {
//        let profileCodable = profile
//
//        do {
//            try db.collection("profiles").document(profile.id.uuidString).setData(from: profileCodable) { error in
//                completion(error)
//            }
//        } catch let error {
//            print("Error writing profile to Firestore: \(error)")
//            completion(error)
//        }
//    }
//
//    func fetchProfileFromFirestore(profileId: UUID, completion: @escaping (ProfileCodable?) -> Void) {
//        let docRef = db.collection("profiles").document(profileId.uuidString)
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                do {
//                    let profileCodable = try document.data(as: ProfileCodable.self)
//                    completion(profileCodable)
//                } catch let error {
//                    print("Error decoding profile from Firestore: \(error)")
//                    completion(nil)
//                }
//            } else {
//                print("Document does not exist")
//                completion(nil)
//            }
//        }
//    }
//}
//
