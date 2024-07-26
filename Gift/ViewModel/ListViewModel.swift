import Foundation
import SwiftData
import SwiftUI
import Firebase

class ListViewModel: ObservableObject {
    @Published var listGifts: [ListGift]
    @Published var listName: String
    @Published var selectedColor: Color
    @Published var expirationDate: Date

    @Published var showAlert = false
    @Published var alertMessage: String = ""

    var modelContext: ModelContext
    private let listGiftManager: ListGiftManager

    init(modelContext: ModelContext,
         listGifts: [ListGift] = [],
         listName: String = "",
         selectedColor: Color = Color("bluePastel"),
         expirationDate: Date = Date(),
         listGiftManager: ListGiftManager? = nil
    ) {
        self.modelContext = modelContext
        self.listGifts = listGifts
        self.listName = listName
        self.selectedColor = selectedColor
        self.expirationDate = expirationDate
        self.listGiftManager = listGiftManager ?? ListGiftManager(modelContext: modelContext)
    }

    func addListGift(name: String, expirationDate: Date, completion: @escaping (Error?) -> Void) {

        if !isValidNameList(name: name) {
            showAlert = true
            alertMessage = "List name can only contain letters."
            Analytics.logEvent("add_list_gift_failure", parameters: ["error": "Invalid list name"])
            completion(ListGiftError.defaultError)
            return
        }

        if name.isEmpty {
            showAlert = true
            alertMessage = "List name cannot be empty."
            Analytics.logEvent("add_list_gift_failure", parameters: ["error": "Empty list name"])
            completion(ListGiftError.defaultError)
            return
        }

        listGiftManager.addListGift(name: name, expirationDate: expirationDate, completion: { result in
            switch result {
            case .success(()):
                completion(nil)
            case .failure(let error):
                self.alertMessage = "error description: \(error.localizedDescription)"
                self.showAlert = true
                completion(ListGiftError.addListError)
            }
        })
    }


    private func isValidNameList(name: String) -> Bool {
        let regex = "^[A-Za-z]+(?:[\\sA-Za-z]+)*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }
}





//import Foundation
//import SwiftData
//import SwiftUI
//import Firebase
//
//class ListViewModel: ObservableObject {
//    @Published var listGifts: [ListGift]
//    @Published var listName: String
//    @Published var selectedColor: Color
//    @Published var expirationDate: Date
//
//    @Published var showAlert = false
//    @Published var alertMessage: String = ""
//
//    var modelContext: ModelContext
//
//    init(modelContext: ModelContext, listGifts: [ListGift] = [], listName: String = "", selectedColor: Color = Color("bluePastel"), expirationDate: Date = Date()) {
//        self.modelContext = modelContext
//        self.listGifts = listGifts
//        self.listName = listName
//        self.selectedColor = selectedColor
//        self.expirationDate = expirationDate
//    }
//
//    func addListGift(name: String, expirationDate: Date) {
//        if !isValidNameList(name: name) {
//            showAlert = true
//            alertMessage = "List name can only contain letters."
//
//            // Log Firebase Analytics event for invalid list name
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Invalid list name"
//            ])
//            return
//        }
//
//        if name.isEmpty {
//            showAlert = true
//            alertMessage = "List name cannot be empty."
//
//            // Log Firebase Analytics event for empty list name
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Empty list name"
//            ])
//            return
//        }
//
//        let newListGift = ListGift(name: name,
//                                   dateCreation: Date(),
//                                   dateExpiration: expirationDate,
//                                   profileId: UUID(),
//                                   gifts: []
//                                   )
//
//        modelContext.insert(newListGift)
//        do {
//            try modelContext.save()
//
//            // Log Firebase Analytics event for successful list addition
//            Analytics.logEvent("add_list_gift_success", parameters: [
//                "name": name,
//                "expiration_date": expirationDate.timeIntervalSince1970
//            ])
//
//        } catch {
//            showAlert = true
//            alertMessage = "Failed to save after adding the list in the database."
//
//            // Log Firebase Analytics event for database save failure
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Database save failure"
//            ])
//        }
//    }
//
//
//
//
//    private func isValidNameList(name: String) -> Bool {
//        let regex = "^[A-Za-z]+(?:[\\sA-Za-z]+)*$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        return predicate.evaluate(with: name)
//    }
//
//}
//
//
////
////func removeListGift(list: ListGift) {
////    if let index = listGifts.firstIndex(where: { $0.id == list.id }) {
////        listGifts.remove(at: index)
////    }
////}
//
//
//
//
///// rajouter le remove de la liste par la date d'expiration , si la date de création est plus grande que la date d'expiration de 1 jour alors on supprime cette liste. D'abord récuperer les données firebase et puis ensuite analyser





//func addListGift(name: String, expirationDate: Date) {
//    guard let user = Auth.auth().currentUser else {
//        showAlert = true
//        alertMessage = "User not authenticated."
//        return
//    }
//
//    if !isValidNameList(name: name) {
//        showAlert = true
//        alertMessage = "List name can only contain letters."
//
//        // Log Firebase Analytics event for invalid list name
//        Analytics.logEvent("add_list_gift_failure", parameters: [
//            "error": "Invalid list name"
//        ])
//        return
//    }
//
//    if name.isEmpty {
//        showAlert = true
//        alertMessage = "List name cannot be empty."
//
//        // Log Firebase Analytics event for empty list name
//        Analytics.logEvent("add_list_gift_failure", parameters: [
//            "error": "Empty list name"
//        ])
//        return
//    }
//
//    let newListGift = ListGift(name: name,
//                               dateCreation: Date(),
//                               dateExpiration: expirationDate,
//                               profileId: UUID(uuidString: user.uid) ?? UUID(), // Use the user's UID as profileId
//                               gifts: []
//                               )
//
//    print("USER ID : \(user.uid)")
//
//    modelContext.insert(newListGift)
//    do {
//        try modelContext.save()
//
//        // Log Firebase Analytics event for successful list addition
//        Analytics.logEvent("add_list_gift_success", parameters: [
//            "name": name,
//            "expiration_date": expirationDate.timeIntervalSince1970
//        ])
//
//        // Convert to Codable and add to Firestore
//        let db = Firestore.firestore()
//        let listGiftCodable = newListGift.toCodable()
//        try db.collection("listGifts").document(newListGift.id.uuidString).setData(from: listGiftCodable)
//
//    } catch {
//        showAlert = true
//        alertMessage = "Failed to save after adding the list in the database."
//
//        // Log Firebase Analytics event for database save failure
//        Analytics.logEvent("add_list_gift_failure", parameters: [
//            "error": "Database save failure"
//        ])
//    }
//}









//func addListGift(name: String, expirationDate: Date) {
//    guard let user = Auth.auth().currentUser else {
//        showAlert = true
//        alertMessage = "User not authenticated."
//        return
//    }
//
//    if !isValidNameList(name: name) {
//        showAlert = true
//        alertMessage = "List name can only contain letters."
//
//        // Log Firebase Analytics event for invalid list name
//        Analytics.logEvent("add_list_gift_failure", parameters: [
//            "error": "Invalid list name"
//        ])
//        return
//    }
//
//    if name.isEmpty {
//        showAlert = true
//        alertMessage = "List name cannot be empty."
//
//        // Log Firebase Analytics event for empty list name
//        Analytics.logEvent("add_list_gift_failure", parameters: [
//            "error": "Empty list name"
//        ])
//        return
//    }
//
//    let db = Firestore.firestore()
//    let userId = user.uid
//
//    // Rechercher l'utilisateur dans la collection "profiles" pour obtenir le "id"
//    db.collection("profiles").whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
//        if let error = error {
//            self.showAlert = true
//            self.alertMessage = "Failed to fetch user profile: \(error.localizedDescription)"
//
//            // Log Firebase Analytics event for profile fetch failure
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Profile fetch failure"
//            ])
//            return
//        }
//
//        guard let documents = querySnapshot?.documents, !documents.isEmpty else {
//            self.showAlert = true
//            self.alertMessage = "User profile not found."
//
//            // Log Firebase Analytics event for profile not found
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Profile not found"
//            ])
//            return
//        }
//
//        // Assume there's only one profile document matching the userId
//        let profileDocument = documents.first
//        guard let profileIdString = profileDocument?.data()["id"] as? String, let profileId = UUID(uuidString: profileIdString) else {
//            self.showAlert = true
//            self.alertMessage = "Invalid profile ID."
//
//            // Log Firebase Analytics event for invalid profile ID
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Invalid profile ID"
//            ])
//            return
//        }
//
//        let newListGift = ListGift(name: name,
//                                   dateCreation: Date(),
//                                   dateExpiration: expirationDate,
//                                   profileId: profileId, // Use the profile ID retrieved
//                                   gifts: []
//                                   )
//
//        self.modelContext.insert(newListGift)
//        do {
//            try self.modelContext.save()
//
//            // Log Firebase Analytics event for successful list addition
//            Analytics.logEvent("add_list_gift_success", parameters: [
//                "name": name,
//                "expiration_date": expirationDate.timeIntervalSince1970
//            ])
//
//            // Convert to Codable and add to Firestore
//            let listGiftCodable = newListGift.toCodable()
//            try db.collection("listGifts").document(newListGift.id.uuidString).setData(from: listGiftCodable)
//
//        } catch {
//            self.showAlert = true
//            self.alertMessage = "Failed to save after adding the list in the database."
//
//            // Log Firebase Analytics event for database save failure
//            Analytics.logEvent("add_list_gift_failure", parameters: [
//                "error": "Database save failure"
//            ])
//        }
//    }
//}
