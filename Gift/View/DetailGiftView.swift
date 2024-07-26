import SwiftUI
import SwiftData

struct DetailGiftView: View {
    var gift: Gift
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModelGift: DetailGiftViewModel
    var backgroundImage: URL?
    var listGift: ListGift

    init(modelContext: ModelContext, gift: Gift, listGift: ListGift) {
        self.gift = gift
        self.listGift = listGift
        _viewModelGift = StateObject(wrappedValue: DetailGiftViewModel(gift: gift, modelContext: modelContext))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let safeBackgroundImage = backgroundImage {
                AsyncImage(url: safeBackgroundImage) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                            .clipped()
                    case .failure(_):
                        Image("giftIconRouge")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                            .clipped()
                            .foregroundColor(.teal)
                            .opacity(0.6)
                    case .empty:
                        Image("giftIconRouge")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                            .clipped()
                            .foregroundColor(.teal)
                            .opacity(0.6)
                    @unknown default:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                    }
                }
            } else {
                Image("giftIconRouge")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                    .clipped()
                    .foregroundColor(.teal)
                    .opacity(0.6)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text(gift.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("grayText"))
                    .padding(.horizontal, 100)

                if let address = gift.address {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(Color("darkBlue"))
                        .padding(.horizontal)
                }

                if let url = gift.url {
                    Text(url.absoluteString)
                        .underline()
                        .font(.subheadline)
                        .foregroundColor(Color("darkBlue"))
                        .padding(.horizontal)
                }

                Text(String(format: "%.2f €", gift.price))
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color("grayText"))
                    .padding(.horizontal)

                if gift.purchased {
                    Text("Purchased")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.horizontal)
                } else {
                    Text("Not Purchased")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 10)

            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    viewModelGift.removeGift(gift: gift, from: listGift)
                    dismiss()
                }) {
                    Text("Delete gift")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color("redPastel"))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
                .padding(.trailing)

                Button(action: {
                    viewModelGift.purchased()
                }) {
                    Text("Purchased")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color("greenPastel"))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
                .padding(.trailing)
            }
            .padding(.top, 10)
        }
        .alert(isPresented: $viewModelGift.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModelGift.alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModelGift.fetchListGiftDetails(listGiftId: listGift.id)
        }
    }
}

