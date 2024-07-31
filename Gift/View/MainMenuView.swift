import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MainMenuView: View {
    @State private var selectedTab = 0
    let profile: ProfileCodable
    let firestore: Firestore
    let auth: Auth

    @MainActor
    init(profile: ProfileCodable) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("redPastel"))
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color("redPastel"))]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        self.profile = profile
        self.firestore = Firestore.firestore()
        self.auth = Auth.auth()
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SearchView(profileId: profile.id)
            }
            .tabItem {
                Label {
                    Text("Search")
                } icon: {
                    Image(systemName: "magnifyingglass.circle")
                }
            }
            .tag(0)

            NavigationView {
                ProfileView(profileId: profile.id)
            }
            .tabItem {
                Label {
                    Text("Profile")
                } icon: {
                    Image(systemName: "person.crop.circle")
                }
            }
            .tag(1)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let profile = ProfileCodable(id: UUID().uuidString, emailAddress: "test@example.com", password: "testtest", fullName: "Test Test", phoneNumber: "1234567890")
    return MainMenuView(profile: profile)
}

