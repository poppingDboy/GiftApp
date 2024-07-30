import Foundation
import Firebase

struct GiftCodable: Codable, Identifiable {
    var id = UUID()
    let name: String
    let price: Double
    let address: String?
    var url: String?
    var purchased: Bool
    let listGift: String
}
