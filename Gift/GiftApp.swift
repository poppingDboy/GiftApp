import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

@main
struct GiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var isUserNotLogged: Bool = true

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel(loggedAction: {
                isUserNotLogged = false
            }))
        }
    }

//    init() {
//        FirebaseApp.configure()
//    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}





//@main
//struct GiftApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @State var isUserNotLogged: Bool = true
//    @State var profileUser: ProfileCodable
//
//    var body: some Scene {
//        WindowGroup {
//            MainMenuView(profile: <#ProfileCodable#>)
//                .fullScreenCover(isPresented: $isUserNotLogged, content: {
//                    LoginView(viewModel: LoginViewModel(loggedAction: {
//                        isUserNotLogged = false
//                    }))
//                })
//                .onAppear(perform: {
//                    // Check if the user is connected with Firebase; if connected, set isUserNotLogged to false
//                    if Auth.auth().currentUser != nil {
//                        isUserNotLogged = false
//                    }
//                })
//        }
//    }
//
//    init() {
//        FirebaseApp.configure()
//    }
//}
