import Foundation
import FirebaseFirestore

class DetailListViewModel: ObservableObject {
    // Published properties to trigger UI updates
    @Published var list: ListGiftCodable
    @Published var giftsToPurchase: [GiftCodable] = []
    @Published var purchasedGifts: [GiftCodable] = []
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    @Published var shareText: String = ""

    // Repository interface for interacting with the data source
    let giftRepo: ListGiftRepositoryInterface

    // Initializer for DetailListViewModel
    init(giftRepo: ListGiftRepositoryInterface = ListGiftRepositoryFirebase(), list: ListGiftCodable) {
        self.giftRepo = giftRepo
        self.list = list
        self.fetchGifts()
    }

    // Function to fetch gifts associated with the list
    func fetchGifts() {
        // Call the repository method to fetch gifts
        giftRepo.fetchGifts(listId: list.id.uuidString) { result in
            switch result {
            case .success(let (giftsToPurchase, purchasedGifts)):
                // Update the properties with fetched data
                self.giftsToPurchase = giftsToPurchase
                self.purchasedGifts = purchasedGifts
            case .failure(let error):
                // Set alert message and show alert if fetching fails
                self.alertMessage = "Failed to fetch gifts"
                self.showAlert = true
            }
        }
    }

    // Function to remove the current list gift
    func removeListGift() {
        // Call the repository method to remove the list gift
        giftRepo.removeListGift(listId: list.id.uuidString) { error in
            if let error {
                switch error {
                case .deleteError:
                    // Set alert message and show alert if deletion fails
                    self.alertMessage = "Failed to delete list"
                    self.showAlert = true
                default:
                    // Handle other errors if needed
                    break
                }
            }
        }
    }
}

