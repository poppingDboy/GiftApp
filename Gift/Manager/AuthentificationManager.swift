import Foundation
import SwiftData
import Firebase

protocol Authentication {
    func signIn(withEmail: String, password: String, loggedAction: @escaping (Result<Void,Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void)
    func disconnect(completion: @escaping () -> Void)
}


enum NetworkError: Error {
    case checkAccountExistFailure
    case defaultError
}


class FirebaseAuthentication: Authentication {
    let db = Firestore.firestore()
    lazy var profilesCollection = db.collection("profiles")

    func signIn(withEmail: String, password: String, loggedAction: @escaping (Result<Void, any Error>) -> Void) {
        profilesCollection.whereField("emailAddress", isEqualTo: withEmail)
            .whereField("password", isEqualTo: password)
            .getDocuments { [weak self] querySnapshot, error in
                guard self != nil else { return }

                if let error = error {
                    // Log Firebase Analytics event for failed account check
                    Analytics.logEvent("Log_Firebase_Analytics_event_for_failed_account_check", parameters: [
                        "email": withEmail
                    ])
                    loggedAction(.failure(error))
                } else {
                    guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                        // Log Firebase Analytics event for failed account check
                        Analytics.logEvent("check_account_exist_failure", parameters: [
                            "email": withEmail
                        ])
                        loggedAction(.failure(NetworkError.checkAccountExistFailure))
                        return
                    }

                    // Successful login
                    loggedAction(.success(()))

                    // Log Firebase Analytics event for successful account check
                    Analytics.logEvent("check_account_exist_success", parameters: [
                        "email": withEmail
                    ])

                    Analytics.logEvent(AnalyticsEventLogin, parameters: [
                        "email": withEmail
                    ])
                }
            }
    }

    func signUp(email: String, password: String, completion: @escaping ((any Error)?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }

    func disconnect(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}


final class AuthenticationManager : Authentication {
    let authentication: Authentication

    init(authentication: Authentication = FirebaseAuthentication()) {
        self.authentication = authentication
    }

    func signIn(withEmail: String, password: String, loggedAction: @escaping (Result<Void,Error>) -> Void) {
        authentication.signIn(withEmail: withEmail, password: password, loggedAction: loggedAction)
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        authentication.signUp(email: email, password: password, completion: completion)
    }

    func disconnect(completion: @escaping () -> Void) {
        authentication.disconnect(completion: {
            completion()
        })
    }
}


final class AuthenticationManagerMock: Authentication {
    var result: Result<Void, Error>
    var errorSignUp: Error?

    init() {
        self.result = .success(())
        self.errorSignUp = NetworkError.defaultError
    }

    func signIn(withEmail: String, password: String, loggedAction: @escaping (Result<Void, any Error>) -> Void) {
        loggedAction(result)
    }

    func signUp(email: String, password: String, completion: @escaping ((any Error)?) -> Void) {
        completion(errorSignUp)
    }

    func disconnect(completion: @escaping () -> Void) {
        completion()
    }
}
