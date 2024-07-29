import Foundation
import FirebaseFirestore

class SearchViewModel: ObservableObject {
    @Published var listGifts: [ListGiftCodable] = []
    @Published var showAlert = false
    @Published var alertMessage = ""

    let firestore: Firestore
    let profileId: String

    init(firestore: Firestore, profileId: String) {
        self.firestore = firestore
        self.profileId = profileId
    }

    func fetchDataFromFirestore() {
        // Fetch all lists from Firestore
        let listsRef = firestore.collection("listGifts")

        listsRef.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert = true
                self.alertMessage = "Error fetching lists: \(error.localizedDescription)"
                print("Error fetching lists: \(error)")
                return
            }

            self.listGifts = snapshot?.documents.compactMap { document in
                try? document.data(as: ListGiftCodable.self)
            } ?? []
        }
    }

    func searchListByIdFromFirestore(id: UUID) {
        let listRef = firestore.collection("listGifts").document(id.uuidString)

        listRef.getDocument { [weak self] document, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert = true
                self.alertMessage = "Error searching list: \(error.localizedDescription)"
                print("Error searching list: \(error)")
                return
            }

            if let document = document, document.exists, let listGift = try? document.data(as: ListGiftCodable.self) {
                self.listGifts = [listGift]
            } else {
                self.showAlert = true
                self.alertMessage = "List not found."
            }
        }
    }
}

