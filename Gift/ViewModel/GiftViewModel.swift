import Foundation
import FirebaseFirestore

class GiftViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var address: String?
    @Published var url: URL?
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let firestore: Firestore
    private let listGiftID: String

    init(firestore: Firestore, listGiftID: String) {
        self.firestore = firestore
        self.listGiftID = listGiftID
    }

    func addGift(name: String, price: Double, address: String?, url: String?, completion: @escaping (Bool) -> Void) {
        let giftId = UUID().uuidString

        let giftData: [String: Any] = [
            "id": giftId,
            "name": name,
            "price": price,
            "address": address ?? "",
            "url": url ?? "",
            "purchased": false,
            "listGift": listGiftID
        ]

        firestore.collection("gifts").document(giftId).setData(giftData) { error in
            if let error = error {
                self.alertMessage = "Failed to add gift: \(error.localizedDescription)"
                self.showAlert = true
                completion(false)
            } else {
                self.alertMessage = "Gift added successfully."
                self.showAlert = true
                completion(true)
            }
        }
    }
}

