//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//class FirestoreService {
//    private let db = Firestore.firestore()
//
//    func addProfile(_ profile: Profile, completion: @escaping (Error?) -> Void) {
//        do {
//            _ = try db.collection("profiles").document(profile.id.uuidString).setData(from: profile)
//            completion(nil)
//        } catch let error {
//            completion(error)
//        }
//    }
//
//    func fetchProfiles(completion: @escaping ([Profile]?, Error?) -> Void) {
//        db.collection("profiles").getDocuments { snapshot, error in
//            if let error = error {
//                completion(nil, error)
//            } else {
//                let profiles = snapshot?.documents.compactMap { doc in
//                    try? doc.data(as: Profile.self)
//                }
//                completion(profiles, nil)
//            }
//        }
//    }
//}
//
