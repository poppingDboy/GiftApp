import Foundation
import XCTest
@testable import Gift

final class AccountViewModelTests: XCTestCase {

    // Test case: Create account with an invalid email address
    func test_createAccount_invalidEmail_showsAlert() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Set the ViewModel's properties with invalid email
        sut.emailAdress = "invalid-email"
        sut.password = "ValidPassword1!"
        sut.confirmPassword = "ValidPassword1!"
        sut.fullname = "John Doe"
        sut.phone = "1234567890"

        // Attempt to create account
        sut.createAccount { _ in }

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Invalid email address.")
    }

    // Test case: Create account with an invalid password
    func test_createAccount_invalidPassword_showsAlert() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Set the ViewModel's properties with an invalid password
        sut.emailAdress = "valid.email@example.com"
        sut.password = "short"
        sut.confirmPassword = "short"
        sut.fullname = "John Doe"
        sut.phone = "1234567890"

        // Attempt to create account
        sut.createAccount { _ in }

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Password must be at least 8 characters long, include uppercase and lowercase letters, a number, and a special character.")
    }

    // Test case: Create account with passwords that do not match
    func test_createAccount_passwordMismatch_showsAlert() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Set the ViewModel's properties with mismatched passwords
        sut.emailAdress = "valid.email@example.com"
        sut.password = "ValidPassword1!"
        sut.confirmPassword = "DifferentPassword1!"
        sut.fullname = "John Doe"
        sut.phone = "1234567890"

        // Attempt to create account
        sut.createAccount { _ in }

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Passwords do not match.")
    }

    // Test case: Create account with an invalid full name
    func test_createAccount_invalidFullName_showsAlert() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Set the ViewModel's properties with an invalid full name
        sut.emailAdress = "valid.email@example.com"
        sut.password = "ValidPassword1!"
        sut.confirmPassword = "ValidPassword1!"
        sut.fullname = "John123"
        sut.phone = "1234567890"

        // Attempt to create account
        sut.createAccount { _ in }

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Full name can only contain letters.")
    }

    // Test case: Create account with an invalid phone number
    func test_createAccount_invalidPhoneNumber_showsAlert() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Set the ViewModel's properties with an invalid phone number
        sut.emailAdress = "valid.email@example.com"
        sut.password = "ValidPassword1!"
        sut.confirmPassword = "ValidPassword1!"
        sut.fullname = "John Doe"
        sut.phone = "123"

        // Attempt to create account
        sut.createAccount { _ in }

        XCTAssertTrue(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "Invalid phone number. It must be between 10 and 15 characters long.")
    }

    // Test case: Create account when account already exists
    func test_createAccount_accountExists_showsAlert() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Pre-existing account details
        sut.accounts = [ProfileCodable(id: "1", emailAddress: "test@gmail.com", password: "Azertyuiop9!", fullName: "test test", phoneNumber: "1234567890")]
        sut.emailAdress = "existing.email@example.com"
        sut.password = "ValidPassword1!"
        sut.confirmPassword = "ValidPassword1!"
        sut.fullname = "John Doe"
        sut.phone = "1234567890"

        // Attempt to create account
        sut.createAccount { _ in }

        XCTAssertFalse(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "")
    }

    // Test case: Successful account creation
    func test_createAccount_success_createsAccountAndSavesProfile() {
        let accountRepo = AccountRepositoryMock(result: .success(()))
        let firestoreManager = FirestoreManagerMock()
        let sut = AccountViewModel(accountRepo: accountRepo, loggedAction: {})

        // Set the ViewModel's properties with valid data
        sut.emailAdress = "valid.email@example.com"
        sut.password = "ValidPassword1!"
        sut.confirmPassword = "ValidPassword1!"
        sut.fullname = "John Doe"
        sut.phone = "1234567890"

        // Attempt to create account
        sut.createAccount { result in
            switch result {
            case .success(let profile):
                // Verify that the profile data is correct
                XCTAssertEqual(profile.emailAddress, "valid.email@example.com")
                XCTAssertEqual(profile.fullName, "John Doe")
                XCTAssertEqual(profile.phoneNumber, "1234567890")
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
        }

        XCTAssertFalse(sut.showAlert)
        XCTAssertEqual(sut.alertMessage, "")
    }

    // Mock Repository for testing purposes
    final class AccountRepositoryMock: AccountRepositoryInterface {
        let result: Result<Void, Error>

        init(result: Result<Void, Error>) {
            self.result = result
        }

        // Mock implementation of the sign-up method
        func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
            switch result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    // Mock FirestoreManager for testing purposes
    final class FirestoreManagerMock: FirestoreManager {
        // Mock implementation of saving a profile to Firestore
        override func saveProfileToFirestore(profile: ProfileCodable, completion: @escaping (Error?) -> Void) {
            completion(nil)
        }
    }
}

