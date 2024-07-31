import Foundation
import FirebaseFirestore

class SearchViewModel: ObservableObject {
    @Published var listGifts: [ListGiftCodable] = []
    @Published var showAlert = false
    @Published var alertMessage = ""

    private let searchRepo: SearchRepositoryInterface

    init(searchRepo: SearchRepositoryInterface) {
        self.searchRepo = searchRepo
    }

    // Fetch all gift lists from Firestore
    func fetchDataFromFirestore() {
        searchRepo.fetchDataFromFirestore { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listGifts):
                // Update the listGifts property with the fetched data
                self.listGifts = listGifts
            case .failure(let error):
                // Show an alert and set an error message if fetching fails
                self.showAlert = true
                self.alertMessage = "Error fetching lists"
                print("Error fetching lists: \(error)")
            }
        }
    }

    // Search for a specific gift list by ID from Firestore
    func searchListByIdFromFirestore(id: UUID) {
        searchRepo.searchListByIdFromFirestore(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listGift):
                // Update the listGifts property with the found list
                self.listGifts = [listGift]
            case .failure(let error):
                // Show an alert and set an error message if searching fails
                self.showAlert = true
                self.alertMessage = "Error searching list"
                print("Error searching list: \(error)")
            }
        }
    }
}

