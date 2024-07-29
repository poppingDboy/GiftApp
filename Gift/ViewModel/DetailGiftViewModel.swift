import Foundation
import FirebaseFirestore

class DetailGiftViewModel: ObservableObject {
    @Published var gift: GiftCodable
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let firestore: Firestore
    private let listGift: ListGiftCodable

    init(firestore: Firestore, gift: GiftCodable, listGift: ListGiftCodable) {
        self.firestore = firestore
        self.gift = gift
        self.listGift = listGift
    }

    func fetchGiftDetails() {
        // Fetch gift details from Firestore if needed
    }

    func removeGift() {
        firestore.collection("listGifts").document(listGift.id.uuidString).collection("gifts").document(gift.id.uuidString).delete() { error in
            if let error = error {
                self.alertMessage = "Failed to delete gift: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                self.alertMessage = "Gift deleted successfully."
                self.showAlert = true
            }
        }
    }

    func markAsPurchased() {
        firestore.collection("listGifts").document(listGift.id.uuidString).collection("gifts").document(gift.id.uuidString).updateData(["purchased": true]) { error in
            if let error = error {
                self.alertMessage = "Failed to mark gift as purchased: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                self.alertMessage = "Gift marked as purchased."
                self.showAlert = true
            }
        }
    }
}

