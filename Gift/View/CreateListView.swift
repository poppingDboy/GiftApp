import SwiftUI
import FirebaseFirestore

struct CreateListView: View {
    @ObservedObject var viewModelList: ListViewModel
    @Environment(\.dismiss) var dismiss

    var onAdd: (() -> Void)?

    init(firestore: Firestore, onAdd: (() -> Void)? = nil) {
        _viewModelList = ObservedObject(wrappedValue: ListViewModel(firestore: firestore))
        self.onAdd = onAdd
    }

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Creating a list")
                        .foregroundColor(Color("grayBackground"))
                        .font(.title)
                    Spacer()
                }
                .padding(.top, 10)

                CustomTextField(placeholder: "Enter the name of the list", text: $viewModelList.listName)
                    .font(.title)
                    .padding(10)
                    .italic()
                    .foregroundColor(Color("grayText"))
                    .cornerRadius(8)
                    .padding(.top, 30)
                    .padding(.horizontal)

                Text("Expiration Date:")
                    .font(.headline)
                    .foregroundColor(Color("grayText"))
                    .padding(.leading, 14)
                    .padding(.top, 20)

                DatePicker("", selection: $viewModelList.expirationDate, displayedComponents: .date)
                    .labelsHidden()
                    .padding(.leading, 14)
                    .padding(.top, 10)

                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        viewModelList.addListGift(name: viewModelList.listName, expirationDate: viewModelList.expirationDate) { error in
                            if error == nil {
                                onAdd?()
                                dismiss()
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
                .padding(.top, 10)
                .padding(.bottom, 10)
                .padding(.trailing)
            }
            .padding()
            .alert(isPresented: $viewModelList.showAlert) {
                Alert(title: Text("List Creation"), message: Text(viewModelList.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    CreateListView(firestore: Firestore.firestore())
}

