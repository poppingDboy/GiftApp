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

    func addListGift(name: String, expirationDate: Date) {
        giftRepo.addListGift(name: name, expirationDate: expirationDate) { error in
            if let error {
                switch error {
                case .defaultError:
                    self.alertMessage = "User not authenticated. Please log in."
                    self.showAlert = true
                case .saveError:
                    self.alertMessage = "Failed to create list"
                    self.showAlert = true
                default:
                    break
                }
            }
        }
    }
}
