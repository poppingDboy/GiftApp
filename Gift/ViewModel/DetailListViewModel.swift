import Foundation
import UIKit
import SwiftData
import Firebase

class DetailListViewModel: ObservableObject {
    @Published var list: ListGift
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var giftsToPurchase: [Gift] = []
    @Published var purchasedGifts: [Gift] = []

    var modelContext: ModelContext
    private let listGiftManager: ListGiftManager

    var shareText: String {
        let idString = list.id.uuidString
        return "Check out this list: \(idString)"
    }

    init(list: ListGift,
         modelContext: ModelContext,
         listGiftManager: ListGiftManager? = nil
    ) {
        self.list = list
        self.modelContext = modelContext
        self.listGiftManager = listGiftManager ?? ListGiftManager(modelContext: modelContext)
        fetchGifts()
    }

    func fetchGifts() {
        let db = Firestore.firestore()
        let listGiftsCollection = db.collection("listGifts")

        listGiftsCollection.document(list.id.uuidString).getDocument { [weak self] documentSnapshot, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert = true
                self.alertMessage = "Error fetching gifts: \(error.localizedDescription)"
                print("Error fetching gifts: \(error)")
                return
            }

            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                self.showAlert = true
                self.alertMessage = "No gifts found for this list."
                print("No gifts found for this list.")
                return
            }

            print("Fetched data: \(data)") // Debug line to check the fetched data
            self.updateGiftsFromData(data)
            self.filterGifts()
        }
    }

    private func updateGiftsFromData(_ data: [String: Any]) {
        if let giftsData = data["gifts"] as? [[String: Any]] {
            var updatedGifts: [Gift] = []
            for giftData in giftsData {
                if let idString = giftData["id"] as? String,
                   let name = giftData["name"] as? String,
                   let price = giftData["price"] as? Double,
                   let address = giftData["address"] as? String?,
                   let urlString = giftData["url"] as? String,
                   let url = URL(string: urlString),
                   let purchased = giftData["purchased"] as? Bool,
                   let listGift = giftData["listGift"] as? String,
                   let id = UUID(uuidString: idString) {
                    let gift = Gift(id: id, name: name, price: price, address: address, url: url, purchased: purchased, listGift: listGift)
                    updatedGifts.append(gift)
                }
            }
            print("Updated gifts: \(updatedGifts)") // Debug line to check the updated gifts
            self.list.gifts = updatedGifts
        } else {
            print("No gifts data found or data format is incorrect")
        }
    }

    private func filterGifts() {
        listGiftManager.filterGifts(gifts: list.gifts) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (giftsToPurchase, purchasedGifts)):
                self.giftsToPurchase = giftsToPurchase
                self.purchasedGifts = purchasedGifts
                self.alertMessage = "List successfully filtered."
                self.showAlert = true
            case .failure(let error):
                self.alertMessage = "Failed to filter list: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }

    func removeListGift(completion: @escaping (Error?) -> Void) {
        listGiftManager.removeListGift(listId: list.id) { result in
            switch result {
            case .success:
                self.alertMessage = "List successfully removed."
                self.showAlert = true
            case .failure(let error):
                self.alertMessage = "Failed to remove list: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
}

