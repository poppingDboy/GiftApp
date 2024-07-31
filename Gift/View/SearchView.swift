import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel: SearchViewModel

    init(searchText: String = "", profileId: String, searchRepo: SearchRepositoryInterface = SearchRepositoryFirebase()) {
        self.searchText = searchText
        self._viewModel = StateObject(wrappedValue: SearchViewModel(searchRepo: searchRepo))
    }

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    HStack {
                        CustomTextField(placeholder: "Search ID List...", text: $searchText)

                        Button(action: {
                            if let uuid = UUID(uuidString: searchText) {
                                viewModel.searchListByIdFromFirestore(id: uuid)
                            } else {
                                print("Invalid UUID format")
                            }
                        }) {
                            Text("Search")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color("redPastel"))
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.top, 10)

                    Spacer()

                    VStack {
                        if viewModel.listGifts.isEmpty {
                            Text("No list to display")
                                .font(.title)
                                .foregroundColor(Color("grayBackground"))
                                .padding()
                        } else {
                            List(viewModel.listGifts, id: \.id) { list in
                                NavigationLink(destination: DetailListView(listGift: list)) {
                                    ListRow(list: list)
                                }
                            }
                            .background(Color.clear)
                        }
                    }
                    .onAppear {
                        viewModel.fetchDataFromFirestore()
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateListView(firestore: Firestore.firestore())) {
                            Text("New list")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color("redPastel"))
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ListRow: View {
    let list: ListGiftCodable

    var body: some View {
        HStack {
            Text(list.name)
        }
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color("pinkPastel"))
            }
        )
    }
}

