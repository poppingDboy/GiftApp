import Foundation
import UIKit
import SwiftData
import SwiftUI
import Firebase

class GiftViewModel: ObservableObject {
    @Published var gifts: [Gift] = []
    @Published var name: String
    @Published var price: String
    @Published var address: String?
    @Published var url: URL?

    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var modelContext: ModelContext
    var listGiftID: String

    init(name: String = "", price: String = "", address: String? = "", url: URL? = URL(string: ""), modelContext: ModelContext, listGiftID: String) {
        self.name = name
        self.price = price
        self.address = address
        self.url = url
        self.modelContext = modelContext
        self.listGiftID = listGiftID
    }

    func addGift(name: String, price: Double, address: String?, url: String?, listGiftID: String) {
//        guard let user = Auth.auth().currentUser else {
//            showAlert = true
//            alertMessage = "User not authenticated."
//            return
//        }

        guard !giftExists(name: name) else {
            showAlert = true
            alertMessage = "Gift with this name already exists."

            // Log Firebase Analytics event for gift name already existing
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Gift with this name already exists."
            ])
            return
        }

        if name.isEmpty {
            showAlert = true
            alertMessage = "Invalid gift name. It should not be empty."

            // Log Firebase Analytics event for empty gift name
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Empty gift name"
            ])
            return
        }

        if !isValidName(name: name) {
            showAlert = true
            alertMessage = "Invalid gift name. It should only contain letters, numbers, and spaces."

            // Log Firebase Analytics event for invalid gift name
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Invalid gift name"
            ])
            return
        }

        if !isValidPrice(price: price) {
            showAlert = true
            alertMessage = "Invalid price. It should be a positive number."

            // Log Firebase Analytics event for invalid price
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Invalid price"
            ])
            return
        }

        if let address = address, !isValidAddress(address: address) {
            showAlert = true
            alertMessage = "Invalid address. It should contain only letters, numbers, spaces, and common address characters."

            // Log Firebase Analytics event for invalid address
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Invalid address"
            ])
            return
        }

        if let urlString = url, !isValidURL(urlString: urlString) {
            showAlert = true
            alertMessage = "Invalid URL."

            // Log Firebase Analytics event for invalid URL
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Invalid URL"
            ])
            return
        }

        let giftURL = URL(string: url ?? "")
        let gift = Gift(name: name, price: price, address: address, url: giftURL, purchased: false, listGift: listGiftID)

//        let fetchDescriptor = FetchDescriptor<ListGift>(predicate: #Predicate { $0.id.uuidString == listGiftID })

        do {
//            let listGifts = try modelContext.fetch(fetchDescriptor)
//            if let listGift = listGifts.first {
                // Add the gift to the listGift's gifts array
//                var updatedGifts = listGift.gifts
//                updatedGifts.append(gift)
//                listGift.gifts = updatedGifts

                // Insert the gift into the model context
                modelContext.insert(gift)


                // Convert to Codable and add to Firestore
                let db = Firestore.firestore()
                let giftCodable = gift.toCodable()
                try db.collection("gifts").document(gift.id.uuidString).setData(from: giftCodable)

//            } else {
//                showAlert = true
//                alertMessage = "ListGift not found."
//
//                // Log Firebase Analytics event for ListGift not found
//                Analytics.logEvent("add_gift_failure", parameters: [
//                    "error": "ListGift not found"
//                ])
//                return
//            }
        } catch {
            showAlert = true
            alertMessage = "Failed to fetch ListGift from the database."

            // Log Firebase Analytics event for fetch failure
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Failed to fetch ListGift from the database"
            ])
            return
        }

        do {
            try modelContext.save()

            // Log Firebase Analytics event for successful gift addition
            Analytics.logEvent("add_gift_success", parameters: [
                "name": name,
                "price": price,
                "address": address ?? "",
                "url": url ?? ""
            ])

        } catch {
            showAlert = true
            alertMessage = "Failed to save after adding the gift in the database."

            // Log Firebase Analytics event for save failure
            Analytics.logEvent("add_gift_failure", parameters: [
                "error": "Failed to save after adding the gift in the database"
            ])
        }
    }



    func isValidName(name: String) -> Bool {
        let regex = "^[A-Za-z0-9 ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }

    func isValidPrice(price: Double) -> Bool {
        return price > 0
    }

    func isValidAddress(address: String) -> Bool {
        let regex = "^[A-Za-z0-9 ,.-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: address)
    }

    func isValidURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    private func giftExists(name: String) -> Bool {
        return gifts.contains { $0.name == name }
    }
}

