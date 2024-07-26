import SwiftUI
import SwiftData

struct MainMenuView: View {
    @State private var selectedTab = 0
    let modelContext: ModelContext
    let profile: Profile

    @MainActor
    init(modelContext: ModelContext, profile: Profile) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("redPastel"))
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color("redPastel"))]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        self.modelContext = modelContext
        self.profile = profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SearchView(modelContext: modelContext, profileId: profile.id)
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
                ProfileView(modelContext: modelContext, profile: profile)
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
    let modelContainer = try! ModelContainer(for: Gift.self, ListGift.self, Profile.self)
    let modelContext = modelContainer.mainContext
    let profile = Profile(emailAddress: "test@exemple.com", password: "testtest", fullName: "test test", phoneNumber: "1234567890")
    return MainMenuView(modelContext: modelContext, profile: profile)
}

