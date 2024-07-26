import Foundation
import SwiftData
import Firebase

class AccountViewModel: ObservableObject {
    @Published var accounts: [Profile] = []
    @Published var emailAdress: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullname: String = ""
    @Published var phone: String = ""

    @Published var showAlert = false
    @Published var alertMessage = ""

    private let loggedAction: () -> Void
    var modelContext: ModelContext
    private let firestoreManager = FirestoreManager()
    private let authManager: AuthenticationManager

    init(modelContext: ModelContext,authManager: AuthenticationManager = AuthenticationManager(),
         loggedAction: @escaping () -> Void) {
        self.modelContext = modelContext
        self.authManager = authManager
        self.loggedAction = loggedAction
    }

    func addAccount(completion: @escaping (Profile?) -> Void) {
        print("Entering addAccount")
        guard !accountExists(email: emailAdress, fullname: fullname) else {
            showAlert = true
            alertMessage = "Account with this email or full name already exists."
            print("Account already exists")
            completion(nil)
            return
        }

        if !isValidEmail(email: emailAdress) {
            showAlert = true
            alertMessage = "Invalid email address."
            print("Invalid email address")
            completion(nil)
            return
        }

        if !isValidPassword(password: password) {
            showAlert = true
            alertMessage = "Password must be at least 8 characters long, include uppercase and lowercase letters, a number, and a special character."
            print("Invalid password")
            completion(nil)
            return
        }

        if !isSamePassword(password: password, confirmPassword: confirmPassword) {
            showAlert = true
            alertMessage = "Passwords do not match."
            print("Passwords do not match")
            completion(nil)
            return
        }

        if !isValidFullName(fullName: fullname) {
            showAlert = true
            alertMessage = "Full name can only contain letters."
            print("Invalid full name")
            completion(nil)
            return
        }

        if !isValidPhoneNumber(phoneNumber: phone) {
            showAlert = true
            alertMessage = "Invalid phone number. It must be between 10 and 15 characters long."
            print("Invalid phone number")
            completion(nil)
            return
        }

        print("All validations passed, proceeding to sign up")

        // Sign up with Firebase
        authManager.signUp(email: emailAdress, password: password) { error in
            if let error = error {
                self.showAlert = true
                self.alertMessage = "Failed to create account: \(error.localizedDescription)"
                print("Sign up failed with error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            print("Sign up successful, creating profile")

            // If sign up is successful, create profile in local database
            let profile = Profile(emailAddress: self.emailAdress, password: self.password, fullName: self.fullname, phoneNumber: self.phone)
            self.modelContext.insert(profile)
            do {
                try self.modelContext.save()
                print("Profile saved to local database")

                // Save profile to Firestore
                self.firestoreManager.saveProfileToFirestore(profile: profile) { error in
                    if let error = error {
                        self.showAlert = true
                        self.alertMessage = "Failed to save profile to Firestore: \(error.localizedDescription)"
                        print("Failed to save profile to Firestore: \(error.localizedDescription)")
                        completion(nil)
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
                    completion(profile)
                }

            } catch {
                self.showAlert = true
                self.alertMessage = "Failed to save after the insert in the database."
                print("Failed to save after insert in the database")
                completion(nil)
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


    /// Swift Data
//    private func fetchData() {
//        do {
//            let descriptor = FetchDescriptor<Profile>(sortBy: [SortDescriptor(\.fullName)])
//            accounts = try modelContext.fetch(descriptor)
//        } catch {
//            print("Fetch failed")
//        }
//    }

