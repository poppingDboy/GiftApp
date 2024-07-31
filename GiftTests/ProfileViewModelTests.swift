import Foundation
import XCTest
@testable import Gift

final class ProfileViewModelTests: XCTestCase {

    // Test case: Initial state of the ViewModel
    func test_initialState_isCorrect() {
        let profileRepo = ProfileRepositoryMock(fetchResult: .success(ProfileCodable(id: "1", emailAddress: "test@gmail.com", password: "Azertyuiop9!", fullName: "test test", phoneNumber: "1234567890")),
                                                disconnectResult: .success(()))
        let sut = ProfileViewModel(profileRepo: profileRepo, profileId: "testID")

        XCTAssertEqual(sut.emailAddress, "")
        XCTAssertEqual(sut.fullname, "")
        XCTAssertEqual(sut.phone, "")
        XCTAssertFalse(sut.isUserLoggedOut)
    }

    // Test case: Fetch user profile successfully
    func test_fetchUserProfile_setsUserProfileOnSuccess() {
        let userProfile = ProfileCodable(id: "1", emailAddress: "test@gmail.com", password: "Azertyuiop9!", fullName: "test test", phoneNumber: "1234567890")
        let profileRepo = ProfileRepositoryMock(fetchResult: .success(userProfile),
                                                disconnectResult: .success(()))
        let sut = ProfileViewModel(profileRepo: profileRepo, profileId: "testID")

        // Fetch user profile and verify that the data is set correctly
        sut.fetchUserProfile()

        XCTAssertEqual(sut.emailAddress, userProfile.emailAddress)
    }

    // Test case: Fetch user profile with an error
    func test_fetchUserProfile_showsErrorOnFailure() {
        let error = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
        let profileRepo = ProfileRepositoryMock(fetchResult: .failure(error),
                                                disconnectResult: .success(()))
        let sut = ProfileViewModel(profileRepo: profileRepo, profileId: "testID")

        // Attempt to fetch user profile and check if error handling works
        sut.fetchUserProfile()

        XCTAssertEqual(sut.emailAddress, "")
        XCTAssertEqual(sut.fullname, "")
        XCTAssertEqual(sut.phone, "")
    }

    // Test case: Disconnect user successfully
    func test_disconnect_setsIsUserLoggedOutOnSuccess() {
        let profileRepo = ProfileRepositoryMock(fetchResult: .success(ProfileCodable(id: "1", emailAddress: "test@gmail.com", password: "Azertyuiop9!", fullName: "test test", phoneNumber: "1234567890")),
                                                disconnectResult: .success(()))
        let sut = ProfileViewModel(profileRepo: profileRepo, profileId: "testID")

        // Disconnect the user and verify that the state changes appropriately
        sut.disconnect()

        XCTAssertTrue(sut.isUserLoggedOut)
    }

    // Test case: Disconnect with an error
    func test_disconnect_showsErrorOnFailure() {
        let error = NSError(domain: "TestError", code: 456, userInfo: [NSLocalizedDescriptionKey: "Logout failed"])
        let profileRepo = ProfileRepositoryMock(fetchResult: .success(ProfileCodable(id: "1", emailAddress: "test@gmail.com", password: "Azertyuiop9!", fullName: "test test", phoneNumber: "1234567890")),
                                                disconnectResult: .failure(error))
        let sut = ProfileViewModel(profileRepo: profileRepo, profileId: "testID")

        // Attempt to disconnect the user and check if error handling works
        sut.disconnect()

        XCTAssertFalse(sut.isUserLoggedOut)
    }

    // Mock implementation of ProfileRepositoryInterface for testing
    final class ProfileRepositoryMock: ProfileRepositoryInterface {
        var fetchResult: Result<ProfileCodable, Error>
        var disconnectResult: Result<Void, Error>

        init(fetchResult: Result<ProfileCodable, Error>, disconnectResult: Result<Void, Error>) {
            self.fetchResult = fetchResult
            self.disconnectResult = disconnectResult
        }

        // Mock method to simulate fetching user profile
        func fetchUserProfile(profileId: String, completion: @escaping (Result<ProfileCodable, Error>) -> Void) {
            completion(fetchResult)
        }

        // Mock method to simulate user disconnect
        func disconnect(completion: @escaping (Result<Void, Error>) -> Void) {
            completion(disconnectResult)
        }
    }
}

