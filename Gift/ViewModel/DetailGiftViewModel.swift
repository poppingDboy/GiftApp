import Foundation
import FirebaseFirestore

class DetailGiftViewModel: ObservableObject {
    // Published properties to trigger UI updates
    @Published var gift: GiftCodable
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let giftRepo: GiftRepositoryInterface
    private let listGift: ListGiftCodable

    // Initializer for DetailGiftViewModel
    init(giftRepo: GiftRepositoryInterface, gift: GiftCodable, listGift: ListGiftCodable) {
        self.giftRepo = giftRepo
        self.gift = gift
        self.listGift = listGift
    }

    // Function to remove the gift
    func removeGift() {
        // Call the repository method to remove the gift
        giftRepo.removeGift(named: gift.name) { result in
            switch result {
            case .success:
                // If the removal is successful, set the alert message and show the alert
                self.alertMessage = "Gift deleted successfully."
                self.showAlert = true
            case .failure(let error):
                // If there is an error, set the alert message and show the alert
                self.alertMessage = "Failed to delete gift"
                self.showAlert = true
            }
        }
    }

    // Function to mark the gift as purchased
    func markAsPurchased() {
        // Call the repository method to mark the gift as purchased
        giftRepo.markAsPurchased(giftName: gift.name) { result in
            switch result {
            case .success:
                // If the update is successful, set the alert message and show the alert
                self.alertMessage = "Gift updated successfully."
                self.showAlert = true
            case .failure(let error):
                // If there is an error, set the alert message and show the alert
                self.alertMessage = "Failed to update gift"
                self.showAlert = true
            }
        }
    }
}

