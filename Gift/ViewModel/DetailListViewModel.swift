import Foundation
import FirebaseFirestore

class DetailListViewModel: ObservableObject {
    @Published var list: ListGiftCodable
    @Published var giftsToPurchase: [GiftCodable] = []
    @Published var purchasedGifts: [GiftCodable] = []
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var shareText: String = ""

    let firestore: Firestore

    init(firestore: Firestore, list: ListGiftCodable) {
        self.firestore = firestore
        self.list = list
        self.fetchGifts()
    }

    func fetchGifts() {
        // Fetch the list of gifts from Firestore based on the list
        // Example: Retrieve gifts for the given list ID
    }

    func removeListGift(completion: @escaping (Error?) -> Void) {
        // Remove the list from Firestore
        let listRef = firestore.collection("listGifts").document(list.id.uuidString)
        listRef.delete { error in
            if let error = error {
                self.alertMessage = "Failed to delete list: \(error.localizedDescription)"
                self.showAlert = true
                completion(error)
            } else {
                self.alertMessage = "List deleted successfully."
                self.showAlert = true
                completion(nil)
            }
        }
    }
}
