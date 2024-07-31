import Foundation
import XCTest
@testable import Gift

final class SearchViewModelTests: XCTestCase {

    // Test case: Initial state of the ViewModel
    func test_initialState_isCorrect() {
        let searchRepo = SearchRepositoryMock(fetchResult: .success([]),
                                              searchResult: .failure(NSError(domain: "TestError", code: 404, userInfo: nil)))
        let sut = SearchViewModel(searchRepo: searchRepo)

        XCTAssertEqual(sut.listGifts.count, 0)
        XCTAssertFalse(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "")
    }

    // Test case: Fetch data from Firestore successfully
    func test_fetchDataFromFirestore_setsListGiftsOnSuccess() {
        let listGifts = [ListGiftCodable(id: UUID(), name: "Test Gift List", dateCreation: Date(), dateExpiration: Date(), profileId: "1")]
        let searchRepo = SearchRepositoryMock(fetchResult: .success(listGifts),
                                              searchResult: .failure(NSError(domain: "TestError", code: 404, userInfo: nil)))
        let sut = SearchViewModel(searchRepo: searchRepo)

        // Fetch data and check if listGifts are set correctly
        sut.fetchDataFromFirestore()

        XCTAssertEqual(sut.listGifts, listGifts)
        XCTAssertFalse(sut.showAlert)
    }

    // Test case: Fetch data from Firestore with an error
    func test_fetchDataFromFirestore_showsErrorOnFailure() {
        let error = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])
        let searchRepo = SearchRepositoryMock(fetchResult: .failure(error),
                                              searchResult: .failure(NSError(domain: "TestError", code: 404, userInfo: nil)))
        let sut = SearchViewModel(searchRepo: searchRepo)

        // Fetch data and check if error handling works
        sut.fetchDataFromFirestore()

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Error fetching lists")
        XCTAssertEqual(sut.listGifts.count, 0)
    }

    // Test case: Search for a list by ID successfully
    func test_searchListByIdFromFirestore_setsListGiftOnSuccess() {
        let listGift = ListGiftCodable(id: UUID(), name: "Test Gift List", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
        let searchRepo = SearchRepositoryMock(fetchResult: .success([]),
                                              searchResult: .success(listGift))
        let sut = SearchViewModel(searchRepo: searchRepo)

        // Search for a list by ID and check if the correct listGift is set
        sut.searchListByIdFromFirestore(id: listGift.id)

        XCTAssertEqual(sut.listGifts, [listGift])
        XCTAssertFalse(sut.showAlert)
    }

    // Test case: Search for a list by ID with an error
    func test_searchListByIdFromFirestore_showsErrorOnFailure() {
        let error = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "List not found"])
        let searchRepo = SearchRepositoryMock(fetchResult: .success([]),
                                              searchResult: .failure(error))
        let sut = SearchViewModel(searchRepo: searchRepo)

        // Attempt to search for a list by ID and check if error handling works
        sut.searchListByIdFromFirestore(id: UUID())

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Error searching list")
        XCTAssertEqual(sut.listGifts.count, 0)
    }

    // Mock implementation of SearchRepositoryInterface for testing
    final class SearchRepositoryMock: SearchRepositoryInterface {
        var fetchResult: Result<[ListGiftCodable], Error>
        var searchResult: Result<ListGiftCodable, Error>

        init(fetchResult: Result<[ListGiftCodable], Error>, searchResult: Result<ListGiftCodable, Error>) {
            self.fetchResult = fetchResult
            self.searchResult = searchResult
        }

        // Mock method to simulate fetching data from Firestore
        func fetchDataFromFirestore(completion: @escaping (Result<[ListGiftCodable], Error>) -> Void) {
            completion(fetchResult)
        }

        // Mock method to simulate searching for a list by ID in Firestore
        func searchListByIdFromFirestore(id: UUID, completion: @escaping (Result<ListGiftCodable, Error>) -> Void) {
            completion(searchResult)
        }
    }
}

