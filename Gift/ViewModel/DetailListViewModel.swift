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
        let giftsRef = firestore.collection("gifts")

        // Filtrer les documents où le champ `listGift` correspond à l'ID de la liste
        let query = giftsRef.whereField("listGift", isEqualTo: list.id.uuidString)

        print("Fetching gifts for list ID: \(list.id.uuidString)")

        query.getDocuments { (snapshot, error) in
            if let error = error {
                self.alertMessage = "Failed to fetch gifts: \(error.localizedDescription)"
                self.showAlert = true
                print("Error fetching gifts: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                let documentCount = snapshot.documents.count
                print("Snapshot count: \(documentCount)")

                if documentCount == 0 {
                    print("No documents found matching the criteria.")
                } else {
                    self.giftsToPurchase = []
                    self.purchasedGifts = []

                    for document in snapshot.documents {
                        print("Document data: \(document.data())") // Affiche les données du document pour le débogage

                        do {
                            var gift = try document.data(as: GiftCodable.self)

                            // Assurez-vous que la conversion de chaîne à URL est correcte si nécessaire
                            if let urlString = document.data()["url"] as? String {
                                gift.url = urlString // Conserve l'url comme String
                            }

                            if gift.purchased {
                                self.purchasedGifts.append(gift)
                            } else {
                                self.giftsToPurchase.append(gift)
                            }
                        } catch {
                            print("Error decoding document: \(error.localizedDescription)")
                        }
                    }

                    print("Gifts to purchase: \(self.giftsToPurchase.count)")
                    print("Purchased gifts: \(self.purchasedGifts.count)")
                }
            } else {
                print("Snapshot is nil")
            }
        }
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
