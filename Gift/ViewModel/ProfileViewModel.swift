import Foundation
import Firebase
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var emailAddress: String = ""
    @Published var fullname: String = ""
    @Published var phone: String = ""
    @Published var isUserLoggedOut = false

    private let profileRepo: ProfileRepositoryInterface
    private let profileId: String

    init(profileRepo: ProfileRepositoryInterface, profileId: String) {
        self.profileRepo = profileRepo
        self.profileId = profileId
    }

    // Function to fetch user profile information
    func fetchUserProfile() {
        // Call the repository method to fetch the user profile
        profileRepo.fetchUserProfile(profileId: profileId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                // On successful fetch, update published properties with the retrieved profile data
                self.emailAddress = userProfile.emailAddress
                self.fullname = userProfile.fullName
                self.phone = userProfile.phoneNumber
            case .failure(let error):
                // Print error message if fetching the profile fails
                print("Error fetching profile: \(error)")
            }
        }
    }

    // Function to disconnect (sign out) the user
    func disconnect() {
        // Call the repository method to sign out the user
        profileRepo.disconnect { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                // On successful sign out, update the flag to indicate the user has logged out
                self.isUserLoggedOut = true
            case .failure(let error):
                // Print error message if signing out fails
                print("Error signing out: \(error)")
            }
        }
    }
}

