import Foundation
import FirebaseFirestore

class GiftViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var address: String?
    @Published var url: URL?
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let giftRepo: GiftRepositoryInterface
    private let listGiftID: String

    init(giftRepo: GiftRepositoryInterface = GiftRepositoryFirebase(), listGiftID: String) {
        self.giftRepo = giftRepo
        self.listGiftID = listGiftID
    }

    // Function to add a new gift to the list
    func addGift(name: String, price: Double, address: String?, url: String?) {
        // Call the repository method to add a gift
        giftRepo.addGift(name: name, price: price, address: address, url: url, listGiftID: listGiftID) { result in
            switch result {
            case .success:
                // If the addition is successful, set the alert message for success
                self.alertMessage = "Gift added successfully."
            case .failure(let error):
                // If there is an error, set the alert message for failure
                self.alertMessage = "Failed to add gift"
            }
            // Show the alert regardless of success or failure
            self.showAlert = true
        }
    }
}

