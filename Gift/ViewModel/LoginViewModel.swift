import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var emailAdress: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    let authManager: AuthenticationManager

    private let loggedAction: (ProfileCodable) -> Void

    /// appeler FirebaseAuthentication
    init(authManager: AuthenticationManager = AuthenticationManager(), loggedAction: @escaping (ProfileCodable) -> Void) {
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
        let profilesRef = Firestore.firestore().collection("profiles")

        // Debugging info
        print("Attempting to log in with email: \(emailAdress) and password: \(password)")

        profilesRef.whereField("emailAddress", isEqualTo: emailAdress)
            .whereField("password", isEqualTo: password)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    // Error occurred during Firestore query
                    print("Error searching for user: \(error.localizedDescription)")
                    self.alertMessage = "Error searching for user: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    print("Firestore query completed successfully.")

                    if let snapshot = snapshot {
                        print("Number of documents found: \(snapshot.documents.count)")

                        guard let document = snapshot.documents.first,
                              let emailAddress = document.data()["emailAddress"] as? String,
                              let password = document.data()["password"] as? String,
                              let fullName = document.data()["fullName"] as? String,
                              let phoneNumber = document.data()["phoneNumber"] as? String
                        else {
                            return
                        }

//                        for document in snapshot.documents {
//                            print("Document ID: \(document.documentID)")
//                            print("Document Data: \(document.data())")
//                        }

                        if !snapshot.isEmpty {
                            print("User found, proceeding with authentication.")
                            self.authManager.signIn(withEmail: self.emailAdress, password: self.password) { result in
                                switch result {
                                case .success(()):
                                    self.loggedAction(ProfileCodable(
                                        emailAddress: emailAddress,
                                        password: password,
                                        fullName: fullName,
                                        phoneNumber: phoneNumber))
                                case .failure(let error):
                                    self.alertMessage = "Authentication Error: \(error.localizedDescription)"
                                    self.showAlert = true
                                }
                            }
                        } else {
                            print("No matching user found in Firestore.")
                            self.alertMessage = "Invalid email or password."
                            self.showAlert = true
                        }
                    } else {
                        print("Snapshot is nil.")
                        self.alertMessage = "No matching user found in Firestore."
                        self.showAlert = true
                    }
                }
            }
    }
}

