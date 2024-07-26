import SwiftUI
import Firebase
import FirebaseCrashlytics
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    let size = UIScreen.main.bounds
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        VStack {
                            Image("giftIconRouge")
                                .resizable()
                                .frame(width: size.width / 3, height: size.height / 5)
                        }
                        .padding(.bottom, 60)

                        VStack(alignment: .leading, spacing: 40) {
                            CustomTextField(placeholder: "Enter your email address", text: $viewModel.emailAdress)
                            CustomSecureField(placeholder: "Enter your password", text: $viewModel.password)
                        }
                        .padding()
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color("redPastel"))
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, -10)

                    NavigationLink(destination: AccountCreateView(viewModel: AccountViewModel(modelContext: viewModel.modelContext, loggedAction: {}))) {
                        Text("Create an account?")
                            .foregroundColor(Color("bluePastel"))
                            .italic()
                            .bold()
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                }
                .frame(width: size.width, height: size.height)
                .background(Color.white)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Login Failed"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
