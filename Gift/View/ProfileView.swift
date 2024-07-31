import SwiftUI
import Firebase

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    init(profileRepo: ProfileRepositoryInterface = ProfileRepositoryFirebase(), profileId: String) {
        self._viewModel = ObservedObject(wrappedValue: ProfileViewModel(profileRepo: profileRepo, profileId: profileId))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                LoginView(viewModel: LoginViewModel(loginRepo: LoginRepositoryFirebase(), loggedAction: { _ in }))
            }
        }
    }
}
