import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCrashlytics
import FirebaseCore
import SwiftData
import FirebaseFirestore

@main
struct GiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isUserNotLogged: Bool = true
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            MainMenuView(modelContext: container.mainContext, profile: Profile(emailAddress: "default@example.com", password: "", fullName: "", phoneNumber: ""))
                .fullScreenCover(isPresented: $isUserNotLogged, content: {
                    LoginView(viewModel: LoginViewModel(modelContext: container.mainContext, loggedAction: {
                        isUserNotLogged = false
                    }))
                })
                .onAppear(perform: {
                    // Check if the user is connected with Firebase; if connected, set isUserNotLogged to false
                    //                    if let _ = Auth.auth().currentUser {
                    //                        isUserNotLogged = false
                    //                    }
                    if Auth.auth().currentUser != nil {
//                        isUserNotLogged = false
                        isUserNotLogged = true
                    }

                })
                .modelContainer(container)
        }
    }

    init() {
        do {
            container = try ModelContainer(for: Gift.self, ListGift.self, Profile.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

//func application(_ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions:
//      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }



//MainMenuView()
//    .fullScreenCover(isPresented: $isUserNotLogged, content: {
//        LoginView(viewModel: AccountViewModel(modelContext: container.mainContext ,loggedAction: {
//            isUserNotLogged = false
//        }))
//    })
//    .onAppear(perform: {
//        // check si l'utilisateur ext connecté avec firebase , si il est connecté passer la variable à false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            isUserNotLogged = false
//        }
//    })
//    .modelContainer(container)




//            AccountCreateView(viewModel: AccountViewModel(modelContext: container.mainContext ,loggedAction: {
//                isUserNotLogged = false
//            }))
//            .modelContainer(container)

//            LoginView(viewModel: AccountViewModel(modelContext: <#T##ModelContext#>, loggedAction: <#T##() -> Void#>))
