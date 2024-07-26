import SwiftUI
import SwiftData
import Firebase

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel: SearchViewModel

    init(searchText: String = "", modelContext: ModelContext, profileId: UUID) {
        self.searchText = searchText
        self._viewModel = StateObject(wrappedValue: SearchViewModel(modelContext: modelContext, profileId: profileId))
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
                                NavigationLink(destination: DetailListView(modelContext: viewModel.modelContext, listGift: list)) {
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
                        NavigationLink(destination: CreateListView(modelContext: viewModel.modelContext, onAdd: viewModel.fetchDataFromFirestore)) {
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
    let modelContainer = try! ModelContainer(for: Gift.self, ListGift.self, Profile.self)
    let modelContext = modelContainer.mainContext
    let profileId = UUID() // Use a valid UUID here for testing
    return SearchView(modelContext: modelContext, profileId: profileId)
}

struct ListRow: View {
    let list: ListGift

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

