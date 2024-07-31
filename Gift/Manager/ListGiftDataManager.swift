import Foundation
import Firebase
import FirebaseFirestore

protocol ListGiftRepositoryInterface {
    func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void)
    func fetchGifts(listId: String, completion: @escaping (Result<([GiftCodable], [GiftCodable]), ListGiftError>) -> Void)
    func removeListGift(listId: String, completion: @escaping (ListGiftError?) -> Void)
}

class ListGiftRepositoryFirebase: ListGiftRepositoryInterface {
    private let db = Firestore.firestore()

    // Function to add a new list gift to Firestore
    func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void) {
        // Ensure that there is a current authenticated user
        guard let user = Auth.auth().currentUser else {
            completion(ListGiftError.defaultError)
            return
        }

        // Generate a unique ID for the new list gift
        let listId = UUID().uuidString
        let listRef = db.collection("listGifts").document(listId)

        // Prepare data dictionary for the new list gift
        let data: [String: Any] = [
            "id": listId,
            "name": name,
            "dateCreation": Timestamp(date: Date()), // Current date as creation date
            "dateExpiration": Timestamp(date: expirationDate), // Provided expiration date
            "profileId": user.uid // ID of the current user
        ]

        // Save the new list gift data to Firestore
        listRef.setData(data) { error in
            if let error = error {
                // Return an error if data could not be saved
                completion(ListGiftError.saveError)
            } else {
                // Return success if the data was saved successfully
                completion(nil)
            }
        }
    }

    // Function to fetch gifts from a specific list
    func fetchGifts(listId: String, completion: @escaping (Result<([GiftCodable], [GiftCodable]), ListGiftError>) -> Void) {
        let giftsRef = db.collection("gifts")
        let query = giftsRef.whereField("listGift", isEqualTo: listId)

        // Query Firestore to find gifts associated with the specified list ID
        query.getDocuments { snapshot, error in
            if let error = error {
                // Return an error if the query fails
                completion(.failure(ListGiftError.fetchError))
            } else if let snapshot = snapshot {
                var giftsToPurchase: [GiftCodable] = []
                var purchasedGifts: [GiftCodable] = []

                // Process each document in the snapshot
                for document in snapshot.documents {
                    do {
                        var gift = try document.data(as: GiftCodable.self)
                        // Update the gift's URL if available
                        if let urlString = document.data()["url"] as? String {
                            gift.url = urlString
                        }

                        // Categorize the gift as purchased or not
                        if gift.purchased {
                            purchasedGifts.append(gift)
                        } else {
                            giftsToPurchase.append(gift)
                        }
                    } catch {
                        // Handle errors in processing document data
                    }
                }
                // Return the lists of gifts to purchase and purchased gifts
                completion(.success((giftsToPurchase, purchasedGifts)))
            } else {
                // Return an error if no documents are found
                completion(.failure(ListGiftError.fetchNoDocumentError))
            }
        }
    }

    // Function to remove a list gift from Firestore
    func removeListGift(listId: String, completion: @escaping (ListGiftError?) -> Void) {
        let listRef = db.collection("listGifts").document(listId)

        // Delete the specified list gift document from Firestore
        listRef.delete { error in
            if let error = error {
                // Return an error if the document could not be deleted
                completion(ListGiftError.deleteError)
            } else {
                // Return success if the document was deleted successfully
                completion(nil)
            }
        }
    }
}

