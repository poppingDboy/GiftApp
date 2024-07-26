import SwiftUI
import SwiftData

struct DetailListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: DetailListViewModel
    @State private var isShowingShareSheet = false

    init(modelContext: ModelContext, listGift: ListGift) {
        _viewModel = ObservedObject(wrappedValue: DetailListViewModel(list: listGift, modelContext: modelContext))
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

                NavigationLink(destination: CreateGiftView(modelContext: modelContext, viewModelDetail: viewModel)) {
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
                            NavigationLink(destination: DetailGiftView(modelContext: modelContext, gift: gift, listGift: viewModel.list)) {
                                GiftRow(gift: gift)
                                    .listRowSeparatorTint(Color(.systemGray))
                            }
                        }
                    }
                }
                .background(Color(.white))

                Section(header: Text("Has already been purchased")) {
                    if viewModel.purchasedGifts.isEmpty {
                        Text("No gift to display")
                            .font(.title)
                            .foregroundColor(Color("grayBackground"))
                            .padding()
                    } else {
                        ForEach(viewModel.purchasedGifts) { gift in
                            NavigationLink(destination: DetailGiftView(modelContext: modelContext, gift: gift, listGift: viewModel.list)) {
                                GiftRow(gift: gift)
                                    .listRowSeparatorTint(Color(.lightGray))
                            }
                        }
                    }
                }
                .background(Color(.white))
            }
            .listStyle(.sidebar)
            .background(Color(.white))
            .scrollContentBackground(.hidden)

            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    viewModel.removeListGift() { error in
                        dismiss()
                    }
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
            print("LA VIEW EST BIEN FRAICHE fraiche fraicheeeee")
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ActivityView(activityItems: [viewModel.shareText])
        }
    }
}




struct GiftRow: View {
    let gift: Gift

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


