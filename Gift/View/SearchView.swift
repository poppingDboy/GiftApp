import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel: SearchViewModel

    init(searchText: String = "", firestore: Firestore, profileId: String) {
        self.searchText = searchText
        self._viewModel = StateObject(wrappedValue: SearchViewModel(firestore: firestore, profileId: profileId))
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
                                NavigationLink(destination: DetailListView(firestore: viewModel.firestore, listGift: list)) {
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
                        NavigationLink(destination: CreateListView(firestore: viewModel.firestore, onAdd: viewModel.fetchDataFromFirestore)) {
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

#Preview {
    let firestore = Firestore.firestore()
    let profileId = UUID().uuidString // Use a valid UUID string for testing
    return SearchView(firestore: firestore, profileId: profileId)
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

