import Foundation
import Firebase
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var emailAddress: String = ""
    @Published var fullname: String = ""
    @Published var phone: String = ""
    @Published var isUserLoggedOut = false

    let firestore: Firestore
    private let profileId: String

    init(firestore: Firestore, profileId: String) {
        self.firestore = firestore
        self.profileId = profileId
    }

    func fetchUserProfile() {
        let profileRef = firestore.collection("profiles").document(profileId)

        profileRef.getDocument { [weak self] document, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching profile: \(error)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                self.emailAddress = data?["emailAddress"] as? String ?? ""
                self.fullname = data?["fullName"] as? String ?? ""
                self.phone = data?["phoneNumber"] as? String ?? ""
            } else {
                print("Profile does not exist.")
            }
        }
    }

    func disconnect() {
        // Sign out the user
        do {
            try Auth.auth().signOut()
            isUserLoggedOut = true
        } catch let error {
            print("Error signing out: \(error)")
        }
    }
}

