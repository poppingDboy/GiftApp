import Foundation
import XCTest
@testable import Gift

class ListGiftViewModelTests: XCTestCase {

    func test_addListGift_doesNotShowAlertOnSuccess() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertFalse(sut.showAlert)
    }

    func test_addListGift_showsAlertWhenUserNotAuthenticated() {
        let listGiftRepo = ListGiftRepositoryMock(error: .defaultError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "User not authenticated. Please log in.")
        XCTAssertTrue(sut.showAlert)
    }

    func test_addListGift_showsAlertOnSaveError() {
        let listGiftRepo = ListGiftRepositoryMock(error: .saveError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "Failed to create list")
        XCTAssertTrue(sut.showAlert)
    }

    func test_addListGift_setsCorrectAlertMessageOnSaveError() {
        let listGiftRepo = ListGiftRepositoryMock(error: .saveError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "Failed to create list")
    }

    func test_addListGift_setsCorrectAlertMessageWhenUserNotAuthenticated() {
        let listGiftRepo = ListGiftRepositoryMock(error: .defaultError)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "Test List", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "User not authenticated. Please log in.")
    }

    func test_addListGift_showsAlertForEmptyListName() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        sut.addListGift(name: "", expirationDate: Date())

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    func test_addListGift_showsAlertForPastExpirationDate() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        sut.addListGift(name: "Valid Name", expirationDate: pastDate)

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }

    func test_initialState_isCorrect() {
        let listGiftRepo = ListGiftRepositoryMock(error: nil)
        let sut = ListViewModel(giftRepo: listGiftRepo)

        XCTAssertEqual(sut.alertMessage, "")
        XCTAssertFalse(sut.showAlert)
    }










    final class ListGiftRepositoryMock: ListGiftRepositoryInterface {
        let error: ListGiftError?

        init(error: ListGiftError?) {
            self.error = error
        }

        func addListGift(name: String, expirationDate: Date, completion: @escaping (ListGiftError?) -> Void) {
            completion(error)
        }

    }


}
