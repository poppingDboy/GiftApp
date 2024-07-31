import Foundation
import FirebaseAuth
import FirebaseFirestore

class ListViewModel: ObservableObject {
    @Published var listName: String = ""
    @Published var expirationDate: Date = Date()
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let giftRepo: ListGiftRepositoryInterface

    init(giftRepo: ListGiftRepositoryInterface = ListGiftRepositoryFirebase()) {
        self.giftRepo = giftRepo
    }

    // Function to add a new gift list
    func addListGift(name: String, expirationDate: Date) {
        // Call the repository's method to add the list gift
        giftRepo.addListGift(name: name, expirationDate: expirationDate) { error in
            if let error {
                // Handle the error if it occurs
                switch error {
                case .defaultError:
                    // If the error indicates the user is not authenticated, set an appropriate alert message
                    self.alertMessage = "User not authenticated. Please log in."
                    self.showAlert = true
                case .saveError:
                    // If the error indicates a failure to save the list, set an appropriate alert message
                    self.alertMessage = "Failed to create list"
                    self.showAlert = true
                default:
                    // Handle any other errors if needed (currently does nothing)
                    break
                }
            }
        }
    }
}

