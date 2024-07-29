import Foundation
import FirebaseAuth
import FirebaseFirestore

class ListViewModel: ObservableObject {
    @Published var listName: String = ""
    @Published var expirationDate: Date = Date()
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let firestore: Firestore

    init(firestore: Firestore) {
        self.firestore = firestore
    }

    func addListGift(name: String, expirationDate: Date, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(ListGiftError.defaultError)
            return
        }

        let listRef = firestore.collection("listGifts").document()

        let data: [String: Any] = [
            "name": name,
            "createdAt": Timestamp(date: Date()),
            "expirationDate": expirationDate,
            "profileId": user.uid

        ]

        listRef.setData(data) { error in
            if let error = error {
                self.alertMessage = "Failed to create list: \(error.localizedDescription)"
                self.showAlert = true
                completion(error)
            } else {
                self.alertMessage = "List created successfully."
                self.showAlert = true
                completion(nil)
            }
        }
    }
}
