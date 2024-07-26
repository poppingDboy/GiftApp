import Foundation
import SwiftData
import Firebase

class ProfileViewModel: ObservableObject {
    var modelContext: ModelContext
    @Published var emailAddress: String
    @Published var fullname: String
    @Published var phone: String
    @Published var isUserLoggedOut = false
    private let authManager: AuthenticationManager

    init(modelContext: ModelContext, profile: Profile, authManager: AuthenticationManager = AuthenticationManager()) {
        self.modelContext = modelContext
        self.emailAddress = profile.emailAddress
        self.fullname = profile.fullName
        self.phone = profile.phoneNumber
        self.authManager = authManager
    }

    func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }

        let db = Firestore.firestore()
        let profilesCollection = db.collection("profiles")

        profilesCollection.whereField("emailAddress", isEqualTo: user.email!)
            .getDocuments { [weak self] querySnapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching user profile: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents, let document = documents.first else {
                    print("No matching user profile found.")
                    return
                }

                let data = document.data()
                self.emailAddress = data["emailAddress"] as? String ?? ""
                self.fullname = data["fullName"] as? String ?? ""
                self.phone = data["phoneNumber"] as? String ?? ""
            }
    }

    func disconnect() {
        authManager.disconnect { [weak self] in
            self?.isUserLoggedOut = true
        }
    }
}

