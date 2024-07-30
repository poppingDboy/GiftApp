import Foundation
import Firebase
import FirebaseFirestore

// MARK: - ListGiftRepositoryInterface
protocol ListGiftRepositoryInterface {
    func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void)
}

// MARK: - ListGiftRepositoryFirebase
class ListGiftRepositoryFirebase: ListGiftRepositoryInterface {
    private let db = Firestore.firestore()
//    private lazy var listGiftsCollection = db.collection("listGifts")

    func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(ListGiftError.defaultError)
            return
        }

        // Generate a new document ID and create a new ListGiftCodable instance
        let listId = UUID().uuidString
        let listRef = db.collection("listGifts").document(listId)

        // Prepare data dictionary
        let data: [String: Any] = [
            "id": listId,
            "name": name,
            "dateCreation": Timestamp(date: Date()),
            "dateExpiration": Timestamp(date: expirationDate),
            "profileId": user.uid
        ]

        // Save data to Firestore
        listRef.setData(data) { error in
            if let error = error {
                completion(ListGiftError.saveError)
            } else {
                completion(nil)
            }
        }
    }
}
