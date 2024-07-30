//import XCTest
//@testable import Gift
//import SwiftData
//import Firebase
//
//final class LoginUseCaseTests: XCTestCase {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    var container: ModelContainer!
//
//    override func setUpWithError() throws {
//        container = try ModelContainer(for: Gift.self, ListGift.self, Profile.self)
//    }
//
//    override func tearDown() {
//        container = nil
//    }
//
//    ///    Vérifie que les propriétés emailAdress et password sont vides à la création du LoginViewModel.
//    @MainActor
//    func test_emailAdressAndPassword_deliversEmptyStringsUponCreation() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        let sut = LoginViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        XCTAssertEqual(sut.emailAdress, "")
//        XCTAssertEqual(sut.password, "")
//    }
//
//    ///    Simule un scénario où la connexion est réussie.
//    ///    Vérifie que showAlert est false et que alertMessage est vide.
//    @MainActor
//    func test_login_successfulLogin_doesNotShowAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = LoginViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "password"
//        sut.login()
//
//        XCTAssertEqual(sut.showAlert, false)
//        XCTAssertTrue(sut.alertMessage.isEmpty)
//    }
//
//    ///    Simule un scénario où la connexion échoue en raison de l'absence de compte correspondant.
//    ///    Vérifie que showAlert est true et que alertMessage contient le message d'erreur approprié.
//    @MainActor
//    func test_login_failedLogin_showsAlertWithError() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .failure(NetworkError.checkAccountExistFailure)
//        let sut = LoginViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "password"
//        sut.login()
//
//        XCTAssertEqual(sut.showAlert, true)
//        XCTAssertEqual(sut.alertMessage, "error description: The operation couldn’t be completed. (Gift.NetworkError error 0.)")
//    }
//
//    ///    Simule un scénario où la connexion échoue en raison d'une erreur réseau.
//    ///    Vérifie que showAlert est true et que alertMessage contient le message d'erreur approprié.
//    @MainActor
//    func test_login_failedLoginDueToNetworkError_showsAlertWithError() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .failure(NetworkError.defaultError)
//        let sut = LoginViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "password"
//        sut.login()
//
//        XCTAssertEqual(sut.showAlert, true)
//        XCTAssertEqual(sut.alertMessage, "error description: The operation couldn’t be completed. (Gift.NetworkError error 1.)")
//    }
//
//    ///    Simule un scénario où la connexion échoue en raison d'une erreur Firebase.
//    ///    Vérifie que showAlert est true et que alertMessage contient le message d'erreur approprié.
//    @MainActor
//    func test_login_failedLoginDueToFirebaseError_showsAlertWithError() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        let firebaseError = NSError(domain: "FirebaseAuthError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Firebase authentication failed."])
//        authManagerMock.result = .failure(firebaseError)
//        let sut = LoginViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "password"
//        sut.login()
//
//        XCTAssertEqual(sut.showAlert, true)
//        XCTAssertEqual(sut.alertMessage, "error description: Firebase authentication failed.")
//    }
//
//    ////
//    ///  AccountViewModel
//    ///
//
//
//    /// Test de Création de Compte Réussie:
//    @MainActor
//    func test_addAccount_successfulCreation() {
//        var loggedActionCallCount = 0
//
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {loggedActionCallCount += 1})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "Password1!"
//        sut.confirmPassword = "Password1!"
//        sut.fullname = "John Doe"
//        sut.phone = "+1234567890"
//
//        let expectation = self.expectation(description: "Account creation should succeed")
//
//        print("Before calling addAccount")
//
//        sut.addAccount { profile in
//            print("In completion block")
//            XCTAssertEqual(loggedActionCallCount, 1)
//            expectation.fulfill()
//        }
//
//        // Log current state for debugging
//        print("Show Alert: \(sut.showAlert)")
//        print("Alert Message: \(sut.alertMessage)")
//
//        // Adjusted timeout to ensure completion of async operations
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//
//
//    /// Test de Compte Existant:
//    @MainActor
//    func test_addAccount_accountExists_showsAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        // Add a profile to simulate existing account
//        let existingProfile = Profile(emailAddress: "testtest@example.com", password: "Password1!", fullName: "John Doe", phoneNumber: "1234567890")
//        sut.accounts.append(existingProfile)
//
//        sut.emailAdress = "testtest@example.com"
//        sut.password = "Password1!"
//        sut.confirmPassword = "Password1!"
//        sut.fullname = "John Doe"
//        sut.phone = "1234567890"
//
//        let expectation = self.expectation(description: "Account creation should fail due to existing account")
//
//        sut.addAccount { profile in
//            XCTAssertNil(profile)
//            XCTAssertTrue(sut.showAlert)
//            XCTAssertEqual(sut.alertMessage, "Account with this email or full name already exists.")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//
//    /// Test d'Email Invalide:
//    @MainActor
//    func test_addAccount_invalidEmail_showsAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "invalid-email"
//        sut.password = "Password1!"
//        sut.confirmPassword = "Password1!"
//        sut.fullname = "John Doe"
//        sut.phone = "+1234567890"
//
//        let expectation = self.expectation(description: "Account creation should fail due to invalid email")
//
//        sut.addAccount { profile in
//            XCTAssertNil(profile)
//            XCTAssertTrue(sut.showAlert)
//            XCTAssertEqual(sut.alertMessage, "Invalid email address.")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    /// Test de Mot de Passe Invalide:
//    @MainActor
//    func test_addAccount_invalidPassword_showsAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "weak"
//        sut.confirmPassword = "weak"
//        sut.fullname = "John Doe"
//        sut.phone = "+1234567890"
//
//        let expectation = self.expectation(description: "Account creation should fail due to invalid password")
//
//        sut.addAccount { profile in
//            XCTAssertNil(profile)
//            XCTAssertTrue(sut.showAlert)
//            XCTAssertEqual(sut.alertMessage, "Password must be at least 8 characters long, include uppercase and lowercase letters, a number, and a special character.")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    /// Test de Non Correspondance des Mots de Passe:
//    @MainActor
//    func test_addAccount_passwordMismatch_showsAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "Password1!"
//        sut.confirmPassword = "Password2!"
//        sut.fullname = "John Doe"
//        sut.phone = "+1234567890"
//
//        let expectation = self.expectation(description: "Account creation should fail due to password mismatch")
//
//        sut.addAccount { profile in
//            XCTAssertNil(profile)
//            XCTAssertTrue(sut.showAlert)
//            XCTAssertEqual(sut.alertMessage, "Passwords do not match.")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    /// Test de Nom Complet Invalide:
//    @MainActor
//    func test_addAccount_invalidFullName_showsAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "Password1!"
//        sut.confirmPassword = "Password1!"
//        sut.fullname = "John123 Doe"
//        sut.phone = "+1234567890"
//
//        let expectation = self.expectation(description: "Account creation should fail due to invalid full name")
//
//        sut.addAccount { profile in
//            XCTAssertNil(profile)
//            XCTAssertTrue(sut.showAlert)
//            XCTAssertEqual(sut.alertMessage, "Full name can only contain letters.")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    ///    Test de Numéro de Téléphone Invalide:
//    @MainActor
//    func test_addAccount_invalidPhoneNumber_showsAlert() {
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//        let sut = AccountViewModel(modelContext: container.mainContext, authManager: authenticationManager, loggedAction: {})
//
//        sut.emailAdress = "test@example.com"
//        sut.password = "Password1!"
//        sut.confirmPassword = "Password1!"
//        sut.fullname = "John Doe"
//        sut.phone = "12345"
//
//        let expectation = self.expectation(description: "Account creation should fail due to invalid phone number")
//
//        sut.addAccount { profile in
//            XCTAssertNil(profile)
//            XCTAssertTrue(sut.showAlert)
//            XCTAssertEqual(sut.alertMessage, "Invalid phone number. It must be between 10 and 15 characters long.")
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//
//    ////
//    ///  ProfileViewModel
//    ///
//
//    @MainActor
//    func test_disconnect_setsIsUserLoggedOutToTrue() {
//        let profile = Profile(emailAddress: "test@example.com", password: "Azertyuiop9!", fullName: "Test User", phoneNumber: "1234567890")
//        let authManagerMock = AuthenticationManagerMock()
//        let authenticationManager = AuthenticationManager(authentication: authManagerMock)
//        authManagerMock.result = .success(())
//
//        let sut = ProfileViewModel(modelContext: container.mainContext, profile: profile, authManager: authenticationManager)
//
//        sut.disconnect()
//
//        XCTAssertTrue(sut.isUserLoggedOut)
//    }
//
//}
//
