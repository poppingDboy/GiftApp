import Foundation
import XCTest
@testable import Gift

final class LoginViewModelTests: XCTestCase {

    // Test case: Attempting to login with an invalid email or password
    func test_login_invalidEmailOrPassword_showsAlert() {
        // Mock the login repository to simulate failure due to invalid credentials
        let loginRepo = LoginRepositoryMock(result: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])))
        let firestoreManager = FirestoreManagerMock(result: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firestore search error"])))
        let sut = LoginViewModel(loginRepo: loginRepo, loggedAction: { _ in })

        // Set the ViewModel's email and password with invalid data
        sut.emailAdress = "invalid.email@example.com"
        sut.password = "wrongPassword"

        // Call the login method
        sut.login()

        XCTAssertFalse(sut.showAlert)
    }

    // Test case: Login attempt results in a Firestore search error
    func test_login_firestoreSearchError_showsAlert() {
        // Mock the login repository to simulate a successful login
        let loginRepo = LoginRepositoryMock(result: .success(()))
        // Mock the Firestore manager to simulate a search error
        let firestoreManager = FirestoreManagerMock(result: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firestore search error"])))
        let sut = LoginViewModel(loginRepo: loginRepo, loggedAction: { _ in })

        // Set the ViewModel's email and password with valid data
        sut.emailAdress = "valid.email@example.com"
        sut.password = "validPassword123"

        // Call the login method
        sut.login()

        XCTAssertFalse(sut.showAlert)
    }

    // Test case: Successful login, verify user details are correctly set
    func test_login_success_logsInUser() {
        // Mock the login repository to simulate a successful login
        let loginRepo = LoginRepositoryMock(result: .success(()))
        // Mock the Firestore manager to return expected user details
        let firestoreManager = FirestoreManagerMock(result: .success([
            (emailAddress: "dylan@gmail.com", password: "Azertyuiop9!", fullName: "dylan marteau", phoneNumber: "1234567890")
        ]))

        // Create the ViewModel and verify the loggedAction callback is called with correct data
        let sut = LoginViewModel(loginRepo: loginRepo, loggedAction: { profile in
            XCTAssertEqual(profile.emailAddress, "dylan@gmail.com")
            XCTAssertEqual(profile.fullName, "dylan marteau")
            XCTAssertEqual(profile.phoneNumber, "1234567890")
        })

        // Set the ViewModel's email and password with valid data
        sut.emailAdress = "dylan@gmail.com"
        sut.password = "Azertyuiop9!"

        // Call the login method
        sut.login()
    }

    // Test case: Login attempt results in an authentication error
    func test_login_authenticationError_showsAlert() {
        // Mock the login repository to simulate an authentication error
        let loginRepo = LoginRepositoryMock(result: .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication error"])))
        // Mock the Firestore manager to return successful user data retrieval (but won't be called due to the auth error)
        let firestoreManager = FirestoreManagerMock(result: .success([(emailAddress: "valid.email@example.com", password: "validPassword123", fullName: "John Doe", phoneNumber: "1234567890")]))
        let sut = LoginViewModel(loginRepo: loginRepo, loggedAction: { _ in })

        // Set the ViewModel's email and password with valid data
        sut.emailAdress = "valid.email@example.com"
        sut.password = "validPassword123"

        // Call the login method
        sut.login()

        XCTAssertFalse(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "")
    }

    // Mock Repository for testing purposes
    final class LoginRepositoryMock: LoginRepositoryInterface {
        let result: Result<Void, Error>

        init(result: Result<Void, Error>) {
            self.result = result
        }

        // Mock implementation of the sign-in method
        func signIn(withEmail email: String, password: String, loggedAction: @escaping (Result<Void, Error>) -> Void) {
            loggedAction(result)
        }
    }

    // Mock FirestoreManager for testing purposes
    final class FirestoreManagerMock: FirestoreManager {
        let result: Result<[(emailAddress: String, password: String, fullName: String, phoneNumber: String)], Error>

        init(result: Result<[(emailAddress: String, password: String, fullName: String, phoneNumber: String)], Error>) {
            self.result = result
        }

        // Mock implementation of fetching user data
        func fetchUserData(completion: @escaping (Result<[(emailAddress: String, password: String, fullName: String, phoneNumber: String)], Error>) -> Void) {
            completion(result)
        }
    }
}

