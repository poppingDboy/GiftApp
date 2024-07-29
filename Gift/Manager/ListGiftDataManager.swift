//import Foundation
//import Firebase
//import FirebaseFirestore
//
//// MARK: - ListGiftRepositoryInterface
//protocol ListGiftRepositoryInterface {
//    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void)
//    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void)
//    func filterGifts(gifts: [GiftCodable], completion: @escaping (Result<([GiftCodable], [GiftCodable]), Error>) -> Void)
//}
//
//// MARK: - ListGiftError
//enum ListGiftError: Error {
//    case defaultError
//    case addListError
//    case removeListGiftError
//    case filterGiftError
//}
//
//// MARK: - ListGiftRepositoryFirebase
//class ListGiftRepositoryFirebase: ListGiftRepositoryInterface {
//    private let db = Firestore.firestore()
//    private lazy var listGiftsCollection = db.collection("listGifts")
//
//    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let user = Auth.auth().currentUser else {
//            completion(.failure(ListGiftError.defaultError))
//            return
//        }
//
//        let newListGift = ListGiftCodable(
//            name: name,
//            dateCreation: Date(),
//            dateExpiration: expirationDate,
//            profileId: user.uid
//        )
//
//        do {
//            try db.collection("listGifts").document(newListGift.id.uuidString).setData(from: newListGift) { error in
//                if let error = error {
//                    Analytics.logEvent("add_list_gift_failure", parameters: ["error": error.localizedDescription])
//                    completion(.failure(ListGiftError.addListError))
//                } else {
//                    Analytics.logEvent("add_list_gift_success", parameters: ["list_id": newListGift.id.uuidString])
//                    completion(.success(()))
//                }
//            }
//        } catch {
//            Analytics.logEvent("add_list_gift_failure", parameters: ["error": error.localizedDescription])
//            completion(.failure(ListGiftError.addListError))
//        }
//    }
//
//    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
//        let documentRef = listGiftsCollection.document(listId.uuidString)
//
//        documentRef.delete { error in
//            if let error = error {
//                Analytics.logEvent("remove_list_gift_failure", parameters: [
//                    "list_id": listId.uuidString,
//                    "error": error.localizedDescription
//                ])
//                completion(.failure(error))
//            } else {
//                Analytics.logEvent("remove_list_gift_success", parameters: [
//                    "list_id": listId.uuidString
//                ])
//                completion(.success(()))
//            }
//        }
//    }
//
//    func filterGifts(gifts: [GiftCodable], completion: @escaping (Result<([GiftCodable], [GiftCodable]), Error>) -> Void) {
//        let giftsToPurchase = gifts.filter { !$0.purchased }
//        let purchasedGifts = gifts.filter { $0.purchased }
//
//        Analytics.logEvent("filter_gifts", parameters: [
//            "total_gifts": gifts.count,
//            "gifts_to_purchase": giftsToPurchase.count,
//            "purchased_gifts": purchasedGifts.count
//        ])
//
//        completion(.success((giftsToPurchase, purchasedGifts)))
//    }
//}
//
//// MARK: - ListGiftManagering
//protocol ListGiftManagering {
//    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void)
//    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void)
//    func filterGifts(gifts: [GiftCodable], completion: @escaping (Result<([GiftCodable], [GiftCodable]), Error>) -> Void)
//}
//
//// MARK: - ListGiftManager
//final class ListGiftManager: ListGiftManagering {
//    let listGiftRepository: ListGiftRepositoryInterface
//
//    init(listGiftRepository: ListGiftRepositoryInterface) {
//        self.listGiftRepository = listGiftRepository
//    }
//
//    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
//        listGiftRepository.addListGift(name: name, expirationDate: expirationDate, completion: completion)
//    }
//
//    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
//        listGiftRepository.removeListGift(listId: listId, completion: completion)
//    }
//
//    func filterGifts(gifts: [GiftCodable], completion: @escaping (Result<([GiftCodable], [GiftCodable]), Error>) -> Void) {
//        listGiftRepository.filterGifts(gifts: gifts, completion: completion)
//    }
//}
//
//// MARK: - ListGiftManagerMock
//final class ListGiftManagerMock: ListGiftManagering {
//    var result: Result<Void, Error> = .success(())
//    var errorListGift: Error?
//
//    func addListGift(name: String, expirationDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
//        completion(result)
//    }
//
//    func removeListGift(listId: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
//        completion(result)
//    }
//
//    func filterGifts(gifts: [GiftCodable], completion: @escaping (Result<([GiftCodable], [GiftCodable]), Error>) -> Void) {
//        let giftsToPurchase = gifts.filter { !$0.purchased }
//        let purchasedGifts = gifts.filter { $0.purchased }
//
//        if let error = errorListGift {
//            completion(.failure(ListGiftError.filterGiftError))
//        } else {
//            completion(.success((giftsToPurchase, purchasedGifts)))
//        }
//    }
//}
//
