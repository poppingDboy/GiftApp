import SwiftUI
import SwiftData

struct CreateListView: View {
    @ObservedObject var viewModelList: ListViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    var onAdd: (() -> Void)?

    init(modelContext: ModelContext, onAdd: (() -> Void)? = nil) {
        _viewModelList = ObservedObject(wrappedValue: ListViewModel(modelContext: modelContext))
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
    CreateListView(modelContext: try! ModelContainer(for: Gift.self, ListGift.self, Profile.self).mainContext)
}











/// liste en detail
/// /// a retirer
//                Spacer()

//                if viewModelGift.gifts.isEmpty {
//                    Spacer()
//                    Text("No gift to display")
//                        .font(.title)
//                        .foregroundColor(Color("grayText"))
//                        .padding()
//                    Spacer()
//                }
// rajouter un else pour afficher avec un foreach les lists de cadeaux


//Text("Choose the background colour :")
//    .font(.headline)
//    .foregroundColor(Color("grayText"))
//    .padding(.top, 10)
//    .padding(.leading, 14)
//
//VStack(spacing: 18) {
//    ForEach(0..<2, id: \.self) { rowIndex in
//        HStack(spacing: 28) {
//            ForEach(viewModelList.colors[rowIndex*5..<min((rowIndex+1)*5, viewModelList.colors.count)], id: \.self) { color in
//                Circle()
//                    .fill(color)
//                    .frame(width: 30, height: 30)
//                    .onTapGesture {
//                        viewModelList.selectedColor = color
//                    }
//                    .overlay(
//                        Circle()
//                            .stroke(Color.red, lineWidth: viewModelList.selectedColor == color ? 3 : 0)
//                    )
//            }
//        }
//    }
//}
//.padding(.bottom, 20)
//.padding(.leading, 14)
