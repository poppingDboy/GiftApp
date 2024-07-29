import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var emailAdress: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    let authManager: AuthenticationManager

    private let loggedAction: () -> Void

    init(authManager: AuthenticationManager = AuthenticationManager(), loggedAction: @escaping () -> Void) {
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
                self.alertMessage = "Error: \(error.localizedDescription)"
                self.showAlert = true
            }
        })
    }
}

