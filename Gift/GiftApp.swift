import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

@main
struct GiftApp: App {
    // Use UIApplicationDelegateAdaptor to connect AppDelegate to the SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // State variables to manage user authentication status and profile data
    @State var isUserNotLogged: Bool = true
    @State var profile: ProfileCodable?

    var body: some Scene {
        WindowGroup {
            // Conditionally render views based on authentication status
            if isUserNotLogged {
                // If the user is not logged in, show the LoginView
                LoginView(viewModel: LoginViewModel(
                    loginRepo: LoginRepositoryFirebase(), // Repository for Firebase login
                    loggedAction: { logprofile in
                        // Update state upon successful login
                        isUserNotLogged = false
                        profile = logprofile
                    }
                ))
            } else if let profile = profile {
                // If the user is logged in, show the MainMenuView
                MainMenuView(profile: profile)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    // This method is called when the app has finished launching
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase SDK
        FirebaseApp.configure()
        return true
    }
}

