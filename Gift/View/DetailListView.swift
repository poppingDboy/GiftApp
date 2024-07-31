import SwiftUI
import FirebaseFirestore

struct DetailListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: DetailListViewModel
    @State private var isShowingShareSheet = false

    init(listGift: ListGiftCodable, giftRepo: ListGiftRepositoryInterface = ListGiftRepositoryFirebase()) {
        _viewModel = ObservedObject(wrappedValue: DetailListViewModel(giftRepo: giftRepo, list: listGift))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()

                Text(viewModel.list.name)
                    .font(.title)
                    .foregroundColor(Color("grayText"))
                    .bold()

                Spacer()

                NavigationLink(destination: CreateGiftView(viewModelDetail: viewModel)) {
                    Text("Add new gift")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color("redPastel"))
                        .cornerRadius(8)
                }
                .padding(.trailing, 10)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()

            List {
                Section(header: Text("Must be purchased")) {
                    if viewModel.giftsToPurchase.isEmpty {
                        Text("No gift to display")
                            .font(.title)
                            .foregroundColor(Color("grayBackground"))
                            .padding()
                    } else {
                        ForEach(viewModel.giftsToPurchase) { gift in
                            NavigationLink(destination: DetailGiftView(gift: gift, listGift: viewModel.list)) {
                                GiftRow(gift: gift)
                            }
                        }
                    }
                }

                Section(header: Text("Has already been purchased")) {
                    if viewModel.purchasedGifts.isEmpty {
                        Text("No gift to display")
                            .font(.title)
                            .foregroundColor(Color("grayBackground"))
                            .padding()
                    } else {
                        ForEach(viewModel.purchasedGifts) { gift in
                            NavigationLink(destination: DetailGiftView(gift: gift, listGift: viewModel.list)) {
                                GiftRow(gift: gift)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .scrollContentBackground(.hidden)

            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    viewModel.removeListGift()
                    dismiss()
                }) {
                    Text("Delete List")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color("redPastel"))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
                .padding(.trailing)

                Button(action: {
                    isShowingShareSheet = true
                }) {
                    Text("Share this list")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color("bluePastel"))
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
                .padding(.trailing)
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchGifts()
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ActivityView(activityItems: [viewModel.shareText])
        }
    }
}

struct GiftRow: View {
    let gift: GiftCodable

    var body: some View {
        HStack {
            Image(systemName: "gift.fill")
                .font(.title)
                .foregroundColor(Color("pinkPastel"))
            Text(gift.name)
            Spacer()
            Text(String(format: "€%.2f", gift.price))
        }
    }
}

#Preview {
    let firestore = Firestore.firestore()
    let listGift = ListGiftCodable(name: "Sample List", dateCreation: Date(), dateExpiration: Date(), profileId: "1")
    let giftRepo = ListGiftRepositoryFirebase() // Replace with actual implementation
    return DetailListView(listGift: listGift, giftRepo: giftRepo)
}

