import Foundation
import SwiftData
import Firebase

class SearchViewModel: ObservableObject {
    @Published var listGifts: [ListGift] = []
    var modelContext: ModelContext
    var profileId: UUID

    init(modelContext: ModelContext, profileId: UUID) {
        self.modelContext = modelContext
        self.profileId = profileId
    }

    func fetchDataFromFirestore() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        let db = Firestore.firestore()
        db.collection("listGifts")
            .whereField("profileId", isEqualTo: user.uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    Analytics.logEvent("fetch_data_failure", parameters: nil)
                    return
                }

                if let querySnapshot = querySnapshot {
                    self.listGifts = querySnapshot.documents.compactMap { document in
                        // Convertir les données du document en ListGiftCodable
                        if let codable = try? document.data(as: ListGiftCodable.self) {
                            // Convertir ListGiftCodable en ListGift
                            return ListGift(from: codable)
                        }
                        return nil
                    }

                    // Log Firebase Analytics event for successful data fetch
                    Analytics.logEvent("fetch_data_success", parameters: [
                        "item_count": self.listGifts.count
                    ])
                }
            }
    }

    func searchListByIdFromFirestore(id: UUID) {
        let db = Firestore.firestore()
        db.collection("listGifts")
            .whereField("id", isEqualTo: id.uuidString)
//            .whereField("profileId", isEqualTo: profileId.uuidString)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Search by ID failed: \(error)")
                    Analytics.logEvent("search_list_by_id_failure", parameters: [
                        "searched_id": id.uuidString
                    ])
                    return
                }

                if let querySnapshot = querySnapshot {
                    self.listGifts = querySnapshot.documents.compactMap { document in
                        // Convertir les données du document en ListGiftCodable
                        if let codable = try? document.data(as: ListGiftCodable.self) {
                            // Convertir ListGiftCodable en ListGift
                            return ListGift(from: codable)
                        }
                        return nil
                    }

                    // Log Firebase Analytics event for successful search
                    Analytics.logEvent("search_list_by_id_success", parameters: [
                        "searched_id": id.uuidString,
                        "result_count": self.listGifts.count
                    ])
                }
            }
    }
}





//func fetchData() {
//    do {
//        let descriptor = FetchDescriptor<ListGift>(predicate: #Predicate { $0.profileId == profileId }, sortBy: [SortDescriptor(\.name)])
//        listGifts = try modelContext.fetch(descriptor)
//
//        // Log Firebase Analytics event for successful data fetch
//        Analytics.logEvent("fetch_data_success", parameters: [
//            "item_count": listGifts.count
//        ])
//
//    } catch {
//        print("Fetch data from SearchViewModel failed")
//
//        // Log Firebase Analytics event for failed data fetch
//        Analytics.logEvent("fetch_data_failure", parameters: nil)
//    }
//}
//
//func searchListById(id: UUID) {
//    do {
//        let descriptor = FetchDescriptor<ListGift>(predicate: #Predicate { $0.id == id && $0.profileId == profileId })
//        let results = try modelContext.fetch(descriptor)
//        listGifts = results
//
//        // Log Firebase Analytics event for successful search
//        Analytics.logEvent("search_list_by_id_success", parameters: [
//            "searched_id": id.uuidString,
//            "result_count": results.count
//        ])
//
//    } catch {
//        print("Search by ID failed")
//
//        // Log Firebase Analytics event for failed search
//        Analytics.logEvent("search_list_by_id_failure", parameters: [
//            "searched_id": id.uuidString
//        ])
//    }
//}
