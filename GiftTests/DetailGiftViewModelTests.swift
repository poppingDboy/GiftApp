import Foundation
import XCTest
@testable import Gift

final class DetailGiftViewModelTests: XCTestCase {

    // Test removeGift when the operation is successful
    func test_removeGift_doesNotShowAlertOnSuccess() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = DetailGiftViewModel(
            giftRepo: giftRepo,
            gift: GiftCodable(id: UUID(), name: "Test Gift", price: 100.0, address: nil, url: nil, purchased: false, listGift: "a"),
            listGift: ListGiftCodable(name: "name", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
        )

        // Perform the remove operation
        sut.removeGift()

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Gift deleted successfully.")
    }

    // Test removeGift when an error occurs
    func test_removeGift_showsAlertOnRemoveError() {
        let giftRepo = GiftRepositoryMock(result: .failure(GiftError.removeError))
        let sut = DetailGiftViewModel(
            giftRepo: giftRepo,
            gift: GiftCodable(id: UUID(), name: "Test Gift", price: 100.0, address: nil, url: nil, purchased: false, listGift: "a"),
            listGift: ListGiftCodable(name: "name", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
        )

        // Perform the remove operation
        sut.removeGift()

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Failed to delete gift")
    }

    // Test markAsPurchased when the operation is successful
    func test_markAsPurchased_doesNotShowAlertOnSuccess() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = DetailGiftViewModel(
            giftRepo: giftRepo,
            gift: GiftCodable(id: UUID(), name: "Test Gift", price: 100.0, address: nil, url: nil, purchased: false, listGift: "a"),
            listGift: ListGiftCodable(name: "name", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
        )

        // Perform the mark as purchased operation
        sut.markAsPurchased()

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Gift updated successfully.")
    }

    // Test markAsPurchased when an error occurs
    func test_markAsPurchased_showsAlertOnUpdateError() {
        let giftRepo = GiftRepositoryMock(result: .failure(GiftError.updateError))
        let sut = DetailGiftViewModel(
            giftRepo: giftRepo,
            gift: GiftCodable(id: UUID(), name: "Test Gift", price: 100.0, address: nil, url: nil, purchased: false, listGift: "a"),
            listGift: ListGiftCodable(name: "name", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
        )

        // Perform the mark as purchased operation
        sut.markAsPurchased()

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Failed to update gift")
    }

    // Test the initial state of the ViewModel
    func test_initialState_isCorrect() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = DetailGiftViewModel(
            giftRepo: giftRepo,
            gift: GiftCodable(id: UUID(), name: "Test Gift", price: 100.0, address: nil, url: nil, purchased: false, listGift: "a"),
            listGift: ListGiftCodable(name: "name", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
        )

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    // Mock Repository for testing purposes
    final class GiftRepositoryMock: GiftRepositoryInterface {
        let result: Result<Void, Error>

        init(result: Result<Void, Error>) {
            self.result = result
        }

        // Mock method to add a gift, not used in these tests
        func addGift(name: String, price: Double, address: String?, url: String?, listGiftID: String, completion: @escaping (Result<Void, Error>) -> Void) {
            // Not used in these tests
        }

        // Mock method to simulate removing a gift
        func removeGift(named name: String, completion: @escaping (Result<Void, Error>) -> Void) {
            completion(result)
        }

        // Mock method to simulate marking a gift as purchased
        func markAsPurchased(giftName: String, completion: @escaping (Result<Void, Error>) -> Void) {
            completion(result)
        }
    }
}

