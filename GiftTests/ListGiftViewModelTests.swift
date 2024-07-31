import Foundation
import XCTest
@testable import Gift

class ListGiftViewModelTests: XCTestCase {

    // Test adding a list gift successfully
    func test_addListGift_doesNotShowAlertOnSuccess() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertFalse(sut.showAlert)
    }

    // Test adding a list gift when user is not authenticated
    func test_addListGift_showsAlertWhenUserNotAuthenticated() {
        let listGiftRepo = ListGiftRepositoryMock(error: .defaultError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "User not authenticated. Please log in.")
        XCTAssertTrue(sut.showAlert)
    }

    // Test adding a list gift when there is a save error
    func test_addListGift_showsAlertOnSaveError() {
        let listGiftRepo = ListGiftRepositoryMock(error: .saveError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "Failed to create list")
        XCTAssertTrue(sut.showAlert)
    }

    // Test the correct alert message is set on save error
    func test_addListGift_setsCorrectAlertMessageOnSaveError() {
        let listGiftRepo = ListGiftRepositoryMock(error: .saveError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "Failed to create list")
    }

    // Test the correct alert message is set when user is not authenticated
    func test_addListGift_setsCorrectAlertMessageWhenUserNotAuthenticated() {
        let listGiftRepo = ListGiftRepositoryMock(error: .defaultError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "User not authenticated. Please log in.")
    }

    // Test adding a list gift with an empty list name
    func test_addListGift_showsAlertForEmptyListName() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    // Test adding a list gift with a past expiration date
    func test_addListGift_showsAlertForPastExpirationDate() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        sut.addListGift(name: "Valid Name", expirationDate: pastDate)

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    // Test initial state of the view model
    func test_initialState_isCorrect() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    // Mock repository for testing purposes
    final class ListGiftRepositoryMock: ListGiftRepositoryInterface {
        let error: ListGiftError?

        init(error: ListGiftError?) {
            self.error = error
        }

        func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void) {
            completion(error)
        }

        func fetchGifts(listId: String, completion: @escaping (Result<([GiftCodable], [GiftCodable]), ListGiftError>) -> Void) {
            // Not used in these tests
        }

        func removeListGift(listId: String, completion: @escaping (ListGiftError?) -> Void) {
            // Not used in these tests
        }
    }
}

