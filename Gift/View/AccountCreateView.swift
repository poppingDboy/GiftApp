import SwiftUI
import FirebaseAuth

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(placeholder, text: $text)
                .padding(8)
                .padding(.leading, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.body)
                .padding(.bottom, 2)
                .overlay(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color("pinkPastel"))
                    }
                )
        }
        .padding(.horizontal, 10)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            SecureField(placeholder, text: $text)
                .padding(8)
                .padding(.leading, 16)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.body)
                .padding(.bottom, 2)
                .overlay(
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color("pinkPastel"))
                    }
                )
        }
        .padding(.horizontal, 10)
    }
}

struct AccountCreateView: View {
    @ObservedObject var viewModel: AccountViewModel
    @State private var navigateToMainMenu = false
    @State private var createdProfile: ProfileCodable?

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Create an account")
                    .foregroundColor(Color("grayBackground"))
                    .font(.title)
                    .padding(.bottom, 40)

                VStack(alignment: .leading, spacing: 20) {
                    CustomTextField(placeholder: "Enter your email address", text: $viewModel.emailAdress)
                    CustomSecureField(placeholder: "Enter your password", text: $viewModel.password)
                    CustomSecureField(placeholder: "Confirm your password", text: $viewModel.confirmPassword)
                    CustomTextField(placeholder: "Enter your full name", text: $viewModel.fullname)
                    CustomTextField(placeholder: "Enter your phone number", text: $viewModel.phone)
                }
                .padding(.horizontal)

                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.createAccount { result in
                            switch result {
                            case .success(let profile):
                                createdProfile = profile
                                navigateToMainMenu = true
                            case .failure(let error):
                                viewModel.showAlert = true
                                viewModel.alertMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Validate")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color("redPastel"))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Account Creation"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }

            if let profile = createdProfile {
                NavigationLink(destination: MainMenuView(profile: profile), isActive: $navigateToMainMenu) {
                    EmptyView()
                }
            }
        }
    }
}
