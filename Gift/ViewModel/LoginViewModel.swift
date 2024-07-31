import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var emailAdress: String = ""
    @Published var password: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    let loginRepo: LoginRepositoryInterface

    private let loggedAction: (ProfileCodable) -> Void

    init(loginRepo: LoginRepositoryInterface, loggedAction: @escaping (ProfileCodable) -> Void) {
        self.loginRepo = loginRepo
        self.loggedAction = loggedAction
    }

    // Function to log in the user
    func login() {
        let profilesRef = Firestore.firestore().collection("profiles")

        // Query Firestore to find a user profile with matching email and password
        profilesRef.whereField("emailAddress", isEqualTo: emailAdress)
            .whereField("password", isEqualTo: password)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    // Handle Firestore query error
                    self.alertMessage = "Error searching for user: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    if let snapshot = snapshot {
                        guard let document = snapshot.documents.first,
                              let uuid = document.data()["id"] as? String,
                              let emailAddress = document.data()["emailAddress"] as? String,
                              let password = document.data()["password"] as? String,
                              let fullName = document.data()["fullName"] as? String,
                              let phoneNumber = document.data()["phoneNumber"] as? String
                        else {
                            // Handle case where data is missing or incorrect
                            return
                        }

                        if !snapshot.isEmpty {
                            // Authenticate with Firebase using the provided email and password
                            self.loginRepo.signIn(withEmail: self.emailAdress, password: self.password) { result in
                                switch result {
                                case .success(()):
                                    // On successful login, execute the loggedAction with the user profile
                                    self.loggedAction(ProfileCodable(
                                        id: uuid,
                                        emailAddress: emailAddress,
                                        password: password,
                                        fullName: fullName,
                                        phoneNumber: phoneNumber))
                                case .failure(let error):
                                    // Handle authentication error
                                    self.alertMessage = "Authentication Error: \(error.localizedDescription)"
                                    self.showAlert = true
                                }
                            }
                        } else {
                            // Handle case where no matching user profile is found
                            self.alertMessage = "Invalid email or password."
                            self.showAlert = true
                        }
                    } else {
                        // Handle case where no matching user profile is found
                        self.alertMessage = "No matching user found in Firestore."
                        self.showAlert = true
                    }
                }
            }
    }
}

