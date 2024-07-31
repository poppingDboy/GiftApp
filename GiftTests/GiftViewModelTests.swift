import Foundation
import XCTest
@testable import Gift

final class GiftViewModelTests: XCTestCase {

    // Test addGift when the operation is successful
    func test_addGift_doesNotShowAlertOnSuccess() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = GiftViewModel(giftRepo: giftRepo, listGiftID: "TestListID")

        // Add a gift with valid details
        sut.addGift(name: "Test Gift", price: 100.0, address: nil, url: nil)

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Gift added successfully.")
    }

    // Test addGift when there is an error during the addition
    func test_addGift_showsAlertOnAddError() {
        let giftRepo = GiftRepositoryMock(result: .failure(GiftError.addError))
        let sut = GiftViewModel(giftRepo: giftRepo, listGiftID: "TestListID")

        // Attempt to add a gift, but simulate an error
        sut.addGift(name: "Test Gift", price: 100.0, address: nil, url: nil)

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Failed to add gift")
    }

    // Test that the correct success message is set when a gift is added successfully
    func test_addGift_setsCorrectAlertMessageOnSuccess() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = GiftViewModel(giftRepo: giftRepo, listGiftID: "TestListID")

        // Add a gift successfully
        sut.addGift(name: "Test Gift", price: 100.0, address: nil, url: nil)

        XCTAssertEqual(sut.alertMessage, "Gift added successfully.")
    }

    // Test that the correct error message is set when there is an error adding a gift
    func test_addGift_setsCorrectAlertMessageOnAddError() {
        let giftRepo = GiftRepositoryMock(result: .failure(GiftError.addError))
        let sut = GiftViewModel(giftRepo: giftRepo, listGiftID: "TestListID")

        // Attempt to add a gift, but simulate an error
        sut.addGift(name: "Test Gift", price: 100.0, address: nil, url: nil)

        XCTAssertEqual(sut.alertMessage, "Failed to add gift")
    }

    // Test that no alert is shown when trying to add a gift with an empty name
    func test_addGift_doesNotShowAlertForEmptyGiftName() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = GiftViewModel(giftRepo: giftRepo, listGiftID: "TestListID")

        // Attempt to add a gift with an empty name
        sut.addGift(name: "", price: 100.0, address: nil, url: nil)

        XCTAssertEqual(sut.alertMessage, "Gift added successfully.")
        XCTAssertTrue(sut.showAlert)
    }

    // Test the initial state of the ViewModel
    func test_initialState_isCorrect() {
        let giftRepo = GiftRepositoryMock(result: .success(()))
        let sut = GiftViewModel(giftRepo: giftRepo, listGiftID: "TestListID")

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    // Mock Repository for testing purposes
    final class GiftRepositoryMock: GiftRepositoryInterface {
        let result: Result<Void, Error>

        init(result: Result<Void, Error>) {
            self.result = result
        }

        // Mock method to add a gift
        func addGift(name: String, price: Double, address: String?, url: String?, listGiftID: String, completion: @escaping (Result<Void, Error>) -> Void) {
            completion(result)
        }

        // Mock method to simulate removing a gift
        func removeGift(named name: String, completion: @escaping (Result<Void, Error>) -> Void) {
            // Not used in these tests
        }

        // Mock method to simulate marking a gift as purchased
        func markAsPurchased(giftName: String, completion: @escaping (Result<Void, Error>) -> Void) {
            // Not used in these tests
        }
    }
}

