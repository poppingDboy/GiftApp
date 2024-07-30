import Foundation
import FirebaseFirestore

class DetailGiftViewModel: ObservableObject {
    @Published var gift: GiftCodable
    @Published var showAlert = false
    @Published var alertMessage: String = ""

    private let firestore: Firestore
    private let listGift: ListGiftCodable

    init(firestore: Firestore, gift: GiftCodable, listGift: ListGiftCodable) {
        self.firestore = firestore
        self.gift = gift
        self.listGift = listGift
    }

    func removeGift() {
        // Référence à la collection `gifts`
        let giftsRef = firestore.collection("gifts")

        // Filtrer les documents où le champ `name` correspond au nom du cadeau
        let query = giftsRef.whereField("name", isEqualTo: gift.name)

        // Exécuter la requête
        query.getDocuments { (snapshot, error) in
            if let error = error {
                self.alertMessage = "Failed to search for gift: \(error.localizedDescription)"
                self.showAlert = true
                print("Error searching for gift: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                // Vérifier s'il y a des documents correspondant
                if snapshot.documents.isEmpty {
                    self.alertMessage = "No gift found with name \(self.gift.name)"
                    self.showAlert = true
                } else {
                    // Traitement du premier document trouvé (ou ajuster pour plusieurs documents si nécessaire)
                    if let document = snapshot.documents.first {
                        // Supprimer le document
                        document.reference.delete() { error in
                            if let error = error {
                                self.alertMessage = "Failed to delete gift: \(error.localizedDescription)"
                                self.showAlert = true
                            } else {
                                self.alertMessage = "Gift deleted successfully."
                                self.showAlert = true
                            }
                        }
                    }
                }
            } else {
                self.alertMessage = "Snapshot is nil"
                self.showAlert = true
            }
        }
    }


    func markAsPurchased() {
        // Référence à la collection `gifts`
        let giftsRef = firestore.collection("gifts")

        // Filtrer les documents où le champ `name` correspond au nom du cadeau
        let query = giftsRef.whereField("name", isEqualTo: gift.name)

        // Exécuter la requête
        query.getDocuments { (snapshot, error) in
            if let error = error {
                self.alertMessage = "Failed to search for gift: \(error.localizedDescription)"
                self.showAlert = true
                print("Error searching for gift: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                // Vérifier s'il y a des documents correspondant
                if snapshot.documents.isEmpty {
                    self.alertMessage = "No gift found with name \(self.gift.name)"
                    self.showAlert = true
                } else {
                    // Traitement du premier document trouvé (ou ajuster pour plusieurs documents si nécessaire)
                    if let document = snapshot.documents.first {
                        // Lire la valeur actuelle du champ `purchased`
                        let currentPurchasedValue = document.data()["purchased"] as? Bool ?? false
                        
                        // Inverser la valeur de `purchased`
                        let newPurchasedValue = !currentPurchasedValue

                        // Mettre à jour le document avec la nouvelle valeur
                        document.reference.updateData(["purchased": newPurchasedValue]) { error in
                            if let error = error {
                                self.alertMessage = "Failed to update gift: \(error.localizedDescription)"
                                self.showAlert = true
                            } else {
                                self.alertMessage = "Gift updated successfully."
                                self.showAlert = true
                            }
                        }
                    }
                }
            } else {
                self.alertMessage = "Snapshot is nil"
                self.showAlert = true
            }
        }
    }


}

