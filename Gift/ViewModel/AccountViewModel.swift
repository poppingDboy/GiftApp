import Foundation
import Firebase

class AccountViewModel: ObservableObject {
    @Published var accounts: [ProfileCodable] = []
    @Published var emailAdress: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullname: String = ""
    @Published var phone: String = ""

    @Published var showAlert = false
    @Published var alertMessage = ""

    private let loggedAction: () -> Void
    private let firestoreManager = FirestoreManager()
    private let authManager: AuthenticationManager

    init(authManager: AuthenticationManager = AuthenticationManager(), loggedAction: @escaping () -> Void) {
        self.authManager = authManager
        self.loggedAction = loggedAction
    }

    func createAccount(completion: @escaping (Result<ProfileCodable, Error>) -> Void) {
        print("Entering addAccount")
        guard !accountExists(email: emailAdress, fullname: fullname) else {
            showAlert = true
            alertMessage = "Account with this email or full name already exists."
            print("Account already exists")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Account with this email or full name already exists."])))
            return
        }

        if !isValidEmail(email: emailAdress) {
            showAlert = true
            alertMessage = "Invalid email address."
            print("Invalid email address")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid email address."])))
            return
        }

        if !isValidPassword(password: password) {
            showAlert = true
            alertMessage = "Password must be at least 8 characters long, include uppercase and lowercase letters, a number, and a special character."
            print("Invalid password")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid password."])))
            return
        }

        if !isSamePassword(password: password, confirmPassword: confirmPassword) {
            showAlert = true
            alertMessage = "Passwords do not match."
            print("Passwords do not match")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match."])))
            return
        }

        if !isValidFullName(fullName: fullname) {
            showAlert = true
            alertMessage = "Full name can only contain letters."
            print("Invalid full name")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Full name can only contain letters."])))
            return
        }

        if !isValidPhoneNumber(phoneNumber: phone) {
            showAlert = true
            alertMessage = "Invalid phone number. It must be between 10 and 15 characters long."
            print("Invalid phone number")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid phone number. It must be between 10 and 15 characters long."])))
            return
        }

        print("All validations passed, proceeding to sign up")

        // Sign up with Firebase
        authManager.signUp(email: emailAdress, password: password) { error in
            if let error = error {
                self.showAlert = true
                self.alertMessage = "Failed to create account: \(error.localizedDescription)"
                print("Sign up failed with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            print("Sign up successful, creating profile")

            // If sign up is successful, create profile in local database
            let profile = ProfileCodable(emailAddress: self.emailAdress, password: self.password, fullName: self.fullname, phoneNumber: self.phone)

            // Save profile to Firestore
            self.firestoreManager.saveProfileToFirestore(profile: profile) { error in
                if let error = error {
                    self.showAlert = true
                    self.alertMessage = "Failed to save profile to Firestore: \(error.localizedDescription)"
                    print("Failed to save profile to Firestore: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                print("Profile saved to Firestore")

                // Log Firebase Analytics event for account creation
                Analytics.logEvent("create_account", parameters: [
                    "email": self.emailAdress,
                    "full_name": self.fullname,
                    "phone": self.phone
                ])

                Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                    "email": self.emailAdress,
                    "full_name": self.fullname,
                    "phone": self.phone
                ])

                self.loggedAction()
                completion(.success(profile))
            }
        }
    }

    private func accountExists(email: String, fullname: String) -> Bool {
        return accounts.contains { $0.emailAddress == email && $0.fullName == fullname }
    }

    // nom@domaine.ext for exemple
    private func isValidEmail(email: String) -> Bool {
        let regex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    // password with 8 characters minimum
    private func isValidPassword(password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }

    private func isSamePassword(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }

    // only letters
    private func isValidFullName(fullName: String) -> Bool {
        let regex = "^[A-Za-z]+(?:[\\sA-Za-z]+)*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: fullName)
    }

    // between 10 and 15 numbers with spaces, hyphens or brackets.
    private func isValidPhoneNumber(phoneNumber: String) -> Bool {
        let regex = "^\\+?[0-9]{10,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phoneNumber)
    }
}

