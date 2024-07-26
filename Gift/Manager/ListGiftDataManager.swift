import Foundation
import SwiftData
import Firebase

protocol ListGiftRepositoryInterface {
    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void)
    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func filterGifts(gifts: [GiftCodable], completion: @escaping (Result<([Gift], [Gift]), Error>) -> Void)
}

enum ListGiftError: Error {
    case defaultError
    case addListError
    case removeListGiftError
    case filterGiftError
}

class ListGiftRepositoryFirebase: ListGiftRepositoryInterface {
    let db = Firestore.firestore()
    lazy var listGiftsCollection = db.collection("listGifts")

    //    var modelContext: ModelContext
    //
    //    // Initialize ModelContext with a ModelContainer that includes all relevant data models
    //    init(modelContext: ModelContext) {
    //        self.modelContext = modelContext
    //    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(ListGiftError.defaultError))
            return
        }

        let newListGift = ListGift(
            name: name,
            dateCreation: Date(),
            dateExpiration: expirationDate,
            profileId: user.uid
        )

        do {
            // Convert to Codable and add to Firestore
            let listGiftCodable = newListGift.toCodable()
            try db.collection("listGifts").document(newListGift.id.uuidString).setData(from: listGiftCodable)

            // Mark as success
            completion(.success(()))
        } catch {
            Analytics.logEvent("add_list_gift_failure", parameters: ["error": "Database save failure"])
            completion(.failure(ListGiftError.addListError))
        }
    }

    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let documentRef = listGiftsCollection.document(listId.uuidString)

        documentRef.delete { error in
            if let error = error {
                Analytics.logEvent("remove_list_gift_failure", parameters: [
                    "list_id": listId.uuidString,
                    "error": error.localizedDescription
                ])
                completion(.failure(error))
            } else {
                Analytics.logEvent("remove_list_gift_success", parameters: [
                    "list_id": listId.uuidString
                ])
                completion(.success(()))
            }
        }
    }

    func filterGifts(gifts: [Gift], completion: @escaping (Result<([Gift], [Gift]), Error>) -> Void) {
        let giftsToPurchase = gifts.filter { !$0.purchased }
        let purchasedGifts = gifts.filter { $0.purchased }

        // Log Firebase Analytics event for filtering gifts
        Analytics.logEvent("filter_gifts", parameters: [
            "total_gifts": gifts.count,
            "gifts_to_purchase": giftsToPurchase.count,
            "purchased_gifts": purchasedGifts.count
        ])

        // Returning the result
        completion(.success((giftsToPurchase, purchasedGifts)))
    }

}

protocol ListGiftManagering {
    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ListGiftManager: ListGiftManagering {
    let listGiftRepository: ListGiftRepositoryInterface

    init(listGift: ListGiftRepositoryInterface) {
        self.listGiftRepository = listGift
    }

    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        listGiftRepository.addListGift(name: name, expirationDate: expirationDate, completion: completion)
    }

    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        listGiftRepository.removeListGift(listId: listId, completion: completion)
    }

    func filterGifts(gifts: [Gift], completion: @escaping (Result<([Gift], [Gift]), Error>) -> Void) {
        //        listGift.filterGifts(gifts: gifts, completion: completion)

        let giftsToPurchase = gifts.filter { !$0.purchased }
        let purchasedGifts = gifts.filter { $0.purchased }

        // Log Firebase Analytics event for filtering gifts
        Analytics.logEvent("filter_gifts", parameters: [
            "total_gifts": gifts.count,
            "gifts_to_purchase": giftsToPurchase.count,
            "purchased_gifts": purchasedGifts.count
        ])

        // Returning the result
        completion(.success((giftsToPurchase, purchasedGifts)))
    }
}

final class ListGiftManagerMock: ListGiftData {
    var result: Result<Void, Error>
    var errorListGift: Error?

    init() {
        self.result = .success(())
    }

    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, any Error>) -> Void) {
        completion(result)
    }

    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(result)
    }

    func filterGifts(gifts: [Gift], completion: @escaping (Result<([Gift], [Gift]), Error>) -> Void) {
        // Simulate filtering logic based on the `purchased` status of the gifts
        let giftsToPurchase = gifts.filter { !$0.purchased }
        let purchasedGifts = gifts.filter { $0.purchased }

        if let error = errorListGift {
            completion(.failure(ListGiftError.filterGiftError))
        } else {
            completion(.success((giftsToPurchase, purchasedGifts)))
        }
    }


}
