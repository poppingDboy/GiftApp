import SwiftUI
import FirebaseFirestore

struct CreateGiftView: View {
    @StateObject var viewModelGift: GiftViewModel
    @ObservedObject var viewModelDetail: DetailListViewModel
    let listId: String

    @Environment(\.dismiss) var dismiss

    init(viewModelDetail: DetailListViewModel) {
        _viewModelGift = StateObject(wrappedValue: GiftViewModel(listGiftID: viewModelDetail.list.id.uuidString))
        self.viewModelDetail = viewModelDetail
        self.listId = viewModelDetail.list.id.uuidString
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 36) {
                    HStack {
                        Spacer()
                        Text("Creating a gift")
                            .foregroundColor(Color("grayBackground"))
                            .font(.title)
                        Spacer()
                    }
                    .padding(.top, 10)

                    Spacer().frame(height: 20)

                    CustomTextField(placeholder: "Enter the name", text: $viewModelGift.name)
                    CustomTextField(placeholder: "Enter the price", text: $viewModelGift.price)
                    CustomTextField(placeholder: "Enter the address", text: Binding(
                        get: { viewModelGift.address ?? "" },
                        set: { viewModelGift.address = $0.isEmpty ? nil : $0 }
                    ))
                    CustomTextField(placeholder: "Enter the url", text: Binding(
                        get: { viewModelGift.url?.absoluteString ?? "" },
                        set: { viewModelGift.url = $0.isEmpty ? nil : URL(string: $0) }
                    ))

                    HStack {
                        Spacer()

                        Button(action: {
                            if let priceValue = Double(viewModelGift.price) {
                                viewModelGift.addGift(
                                    name: viewModelGift.name,
                                    price: priceValue,
                                    address: viewModelGift.address,
                                    url: viewModelGift.url?.absoluteString
                                )
                                dismiss()
                            } else {
                                viewModelGift.alertMessage = "Please enter a valid price."
                                viewModelGift.showAlert = true
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
                    .padding(.bottom, 20)
                }
                .padding()
                .alert(isPresented: $viewModelGift.showAlert) {
                    Alert(title: Text("Add Gift"), message: Text(viewModelGift.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

#Preview {
    let firestore = Firestore.firestore()
    let listId = "sampleListId" // Replace with a valid list ID
    let viewModelDetail = DetailListViewModel(list: ListGiftCodable(id: UUID(), name: "Sample List", dateCreation: Date(), dateExpiration: Date(), profileId: "1"))
    return CreateGiftView(viewModelDetail: viewModelDetail)
}

