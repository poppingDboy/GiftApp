import Foundation
import SwiftData
import Firebase

class LoginViewModel: ObservableObject {
    @Published var emailAdress: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    private let authManager: AuthenticationManager

    var modelContext: ModelContext
    private let loggedAction: () -> Void

    init(modelContext: ModelContext, authManager: AuthenticationManager = AuthenticationManager(), loggedAction: @escaping () -> Void) {
        self.modelContext = modelContext
        self.authManager = authManager
        self.loggedAction = loggedAction

        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("User is signed in: \(user.email!)")
                // Vous pouvez appeler loggedAction() ici si nécessaire
            } else {
                print("No user is signed in.")
            }
        }
    }

    func login() {
        authManager.signIn(withEmail: emailAdress, password: password, loggedAction: { result in
            switch result {
            case .success(()):
                self.loggedAction()
            case .failure(let error):
                self.alertMessage = "error description: \(error.localizedDescription)"
                self.showAlert = true
            }
        })
    }
}



//    private func fetchEmailsAndPasswords() -> ([String], [String]) {
//        do {
//            let descriptor = FetchDescriptor<Profile>(sortBy: [SortDescriptor(\.fullName)])
//            let profiles = try modelContext.fetch(descriptor)
//
//            let emailAddresses = profiles.map { $0.emailAddress }
//            let passwords = profiles.map { $0.password }
//
//            return (emailAddresses, passwords)
//        } catch {
//            print("Fetch failed")
//            return ([], [])
//        }
//    }






//    private func fetchData() {
//        do {
//            let descriptor = FetchDescriptor<Profile>(sortBy: [SortDescriptor(\.fullName)])
//            accounts = try modelContext.fetch(descriptor)
//        } catch {
//            print("Fetch failed")
//        }
//    }


//    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            completion(error)
//        }
//    }
//
//
//    func checkAccountExist() {
//        let (emailAddresses, passwords) = fetchEmailsAndPasswords()
//        if let emailIndex = emailAddresses.firstIndex(of: emailAdress), passwords[emailIndex] == password {
//            loggedAction()
//
//            // Log Firebase Analytics event for successful account check
//            Analytics.logEvent("check_account_exist_success", parameters: [
//                "email": emailAdress
//            ])
//
//        } else {
//            alertMessage = "Invalid email or password."
//            showAlert = true
//
//            // Log Firebase Analytics event for failed account check
//            Analytics.logEvent("check_account_exist_failure", parameters: [
//                "email": emailAdress
//            ])
//        }
//    }
