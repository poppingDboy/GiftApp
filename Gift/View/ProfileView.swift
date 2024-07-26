import SwiftUI
import SwiftData

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    init(modelContext: ModelContext, profile: Profile) {
        self._viewModel = ObservedObject(wrappedValue: ProfileViewModel(modelContext: modelContext, profile: profile))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Profile information
            HStack {
                Text("Email address: ")
                    .font(.headline)
                    .foregroundColor(Color("grayText"))

                Spacer()

                Text(viewModel.emailAddress)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Text("Full name:  ")
                    .font(.headline)
                    .foregroundColor(Color("grayText"))

                Spacer()

                Text(viewModel.fullname)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Text("Phone number:  ")
                    .font(.headline)
                    .foregroundColor(Color("grayText"))

                Spacer()

                Text(viewModel.phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Disconnect button
            HStack {
                Spacer()

                Button(action: {
                    viewModel.disconnect()
                }) {
                    Text("Disconnect")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color("redPastel"))
                        .cornerRadius(8)
                }
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            }
        }
        .padding()
        .foregroundColor(Color("grayText"))
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .onAppear {
            viewModel.fetchUserProfile()
        }
        .fullScreenCover(isPresented: $viewModel.isUserLoggedOut) {
            NavigationView {
                LoginView(viewModel: LoginViewModel(modelContext: viewModel.modelContext, loggedAction: {}))
            }
        }
    }
}


#Preview {
    let modelContainer = try! ModelContainer(for: Gift.self, ListGift.self, Profile.self)
    let modelContext = modelContainer.mainContext
    let profile = Profile(emailAddress: "test@exemple.com", password: "testtest", fullName: "test test", phoneNumber: "1234567890")
    return ProfileView(modelContext: modelContext, profile: profile)
}

