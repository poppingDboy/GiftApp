import Foundation
import FirebaseFirestore

protocol GiftRepositoryInterface {
    func addGift(name: String, price: Double, address: String?, url: String?, listGiftID: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeGift(named name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func markAsPurchased(giftName: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class GiftRepositoryFirebase: GiftRepositoryInterface {
    private let db = Firestore.firestore()

    // Function to add a new gift to Firestore
    func addGift(name: String, price: Double, address: String?, url: String?, listGiftID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let giftId = UUID().uuidString

        // Create a dictionary with gift details
        let giftData: [String: Any] = [
            "id": giftId,
            "name": name,
            "price": price,
            "address": address ?? "",
            "url": url ?? "",
            "purchased": false,
            "listGift": listGiftID
        ]

        // Add the gift data to the Firestore "gifts" collection
        db.collection("gifts").document(giftId).setData(giftData) { error in
            if let error = error {
                // Return an error if the data could not be added
                completion(.failure(GiftError.addError))
            } else {
                // Return success if the data was added successfully
                completion(.success(()))
            }
        }
    }

    // Function to remove a gift from Firestore based on its name
    func removeGift(named name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let giftsRef = db.collection("gifts")
        let query = giftsRef.whereField("name", isEqualTo: name)

        // Query Firestore to find the gift with the specified name
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // Return an error if the query fails
                completion(.failure(GiftError.removeError))
            } else if let snapshot = snapshot, let document = snapshot.documents.first {
                // Delete the document if found
                document.reference.delete { error in
                    if let error = error {
                        // Return an error if the document could not be deleted
                        completion(.failure(GiftError.removeError))
                    } else {
                        // Return success if the document was deleted successfully
                        completion(.success(()))
                    }
                }
            } else {
                // Return an error if no matching document is found
                completion(.failure(GiftError.notFoundError))
            }
        }
    }

    // Function to mark a gift as purchased
    func markAsPurchased(giftName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let giftsRef = db.collection("gifts")
        let query = giftsRef.whereField("name", isEqualTo: giftName)

        // Query Firestore to find the gift with the specified name
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // Return an error if the query fails
                completion(.failure(GiftError.updateError))
            } else if let snapshot = snapshot, let document = snapshot.documents.first {
                // Toggle the "purchased" status of the gift
                let currentPurchasedValue = document.data()["purchased"] as? Bool ?? false
                let newPurchasedValue = !currentPurchasedValue

                document.reference.updateData(["purchased": newPurchasedValue]) { error in
                    if let error = error {
                        // Return an error if the update fails
                        completion(.failure(GiftError.updateError))
                    } else {
                        // Return success if the update was successful
                        completion(.success(()))
                    }
                }
            } else {
                // Return an error if no matching document is found
                completion(.failure(GiftError.notFoundError))
            }
        }
    }
}

