import Foundation
import SwiftData
import Firebase

class DetailGiftViewModel: ObservableObject {
    @Published var gift: Gift
    @Published var showAlert = false
    @Published var alertMessage = ""
    var modelContext: ModelContext

    init(gift: Gift, modelContext: ModelContext) {
        self.gift = gift
        self.modelContext = modelContext
    }

    func fetchListGiftDetails(listGiftId: UUID) {
        // Fetch the details of the list gift by ID
        // This is a placeholder for the actual fetching logic
        // You need to implement the fetching from your data source (e.g., CoreData, API)
    }

    func removeGift(gift: Gift, from listGift: ListGift) {
        if gift.purchased {
            showAlert = true
            alertMessage = "Cannot delete a purchased gift."

            // Log Firebase Analytics event for attempting to delete a purchased gift
            Analytics.logEvent("remove_gift_failure", parameters: [
                "gift_name": gift.name,
                "error": "Cannot delete a purchased gift."
            ])
            return
        }

        do {
            // Remove the gift from the ListGift's gifts array
            if let index = listGift.gifts.firstIndex(of: gift) {
                listGift.gifts.remove(at: index)
            } else {
                showAlert = true
                alertMessage = "Gift not found in the list."

                // Log Firebase Analytics event for gift not found
                Analytics.logEvent("remove_gift_failure", parameters: [
                    "gift_name": gift.name,
                    "error": "Gift not found in the list."
                ])
                return
            }

            // Delete the gift from the model context
            modelContext.delete(gift)

            // Save the changes to the model context
            try modelContext.save()

            // Log Firebase Analytics event for successful deletion
            Analytics.logEvent("remove_gift_success", parameters: [
                "gift_name": gift.name,
                "list_id": listGift.id.uuidString
            ])

        } catch {
            showAlert = true
            alertMessage = "Failed to delete the gift from the database."

            // Log Firebase Analytics event for save failure
            Analytics.logEvent("remove_gift_failure", parameters: [
                "gift_name": gift.name,
                "error": "Failed to delete gift from database."
            ])
        }
    }

    func purchased() {
        do {
            gift.purchased.toggle()
            try modelContext.save()

            // Log Firebase Analytics event for successful purchase status update
            Analytics.logEvent("update_purchase_status_success", parameters: [
                "gift_name": gift.name,
                "purchased": gift.purchased
            ])

        } catch {
            showAlert = true
            alertMessage = "Failed to update the purchase status."

            // Log Firebase Analytics event for failed purchase status update
            Analytics.logEvent("update_purchase_status_failure", parameters: [
                "gift_name": gift.name,
                "error": "Failed to save purchase status."
            ])
        }
    }
}

