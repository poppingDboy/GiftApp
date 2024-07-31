import XCTest
@testable import Gift

final class DetailListViewModelTests: XCTestCase {

    // Test fetchGifts when the operation is successful
    func test_fetchGifts_success() {
        let expectedGiftsToPurchase = [GiftCodable(name: "name",
                                                   price: 1,
                                                   address: "a 1",
                                                   purchased: false,
                                                   listGift: "")]
        let expectedPurchasedGifts = [GiftCodable(name: "name2",
                                                  price: 2,
                                                  address: "a 2",
                                                  purchased: true,
                                                  listGift: "")]
        let giftRepo = ListGiftRepositoryMock(fetchGiftsResult: .success((expectedGiftsToPurchase, expectedPurchasedGifts)))
        let sut = DetailListViewModel(giftRepo: giftRepo, list: ListGiftCodable(id: UUID(), name: "Sample List", dateCreation: Date(), dateExpiration: Date(), profileId: "1"))

        sut.fetchGifts()

        XCTAssertFalse(sut.showAlert)
    }

    // Test fetchGifts when there is an error during the fetch operation
    func test_fetchGifts_failure() {
        let giftRepo = ListGiftRepositoryMock(fetchGiftsResult: .failure(.fetchError))
        let sut = DetailListViewModel(giftRepo: giftRepo, list: ListGiftCodable(id: UUID(), name: "Sample List", dateCreation: Date(), dateExpiration: Date(), profileId: "1"))

        sut.fetchGifts()

        XCTAssertTrue(sut.giftsToPurchase.isEmpty)
        XCTAssertTrue(sut.purchasedGifts.isEmpty)
        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Failed to fetch gifts")
    }

    // Test removeListGift when the operation is successful
    func test_removeListGift_success() {
        let giftRepo = ListGiftRepositoryMock(removeListGiftError: nil)
        let sut = DetailListViewModel(giftRepo: giftRepo, list: ListGiftCodable(id: UUID(), name: "Sample List", dateCreation: Date(), dateExpiration: Date(), profileId: "1"))

        sut.removeListGift()

        XCTAssertTrue(sut.showAlert)
    }

    // Test removeListGift when there is an error during the removal operation
    func test_removeListGift_failure() {
        let giftRepo = ListGiftRepositoryMock(removeListGiftError: .deleteError)
        let sut = DetailListViewModel(giftRepo: giftRepo, list: ListGiftCodable(id: UUID(), name: "Sample List", dateCreation: Date(), dateExpiration: Date(), profileId: "1"))

        sut.removeListGift()

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Failed to delete list")
    }

    // Mock repository for testing
    final class ListGiftRepositoryMock: ListGiftRepositoryInterface {
        var fetchGiftsResult: Result<([GiftCodable], [GiftCodable]), ListGiftError>?
        var removeListGiftError: ListGiftError?

        init(fetchGiftsResult: Result<([GiftCodable], [GiftCodable]), ListGiftError>? = nil, removeListGiftError: ListGiftError? = nil) {
            self.fetchGiftsResult = fetchGiftsResult
            self.removeListGiftError = removeListGiftError
        }

        func fetchGifts(listId: String, completion: @escaping (Result<([GiftCodable], [GiftCodable]), ListGiftError>) -> Void) {
            if let result = fetchGiftsResult {
                completion(result)
            } else {
                completion(.failure(.fetchError))
            }
        }

        func removeListGift(listId: String, completion: @escaping (ListGiftError?) -> Void) {
            completion(removeListGiftError)
        }

        func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void) {
            // Not used in these tests
        }
    }
}

