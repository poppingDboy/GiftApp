import Foundation
import Firebase

struct GiftCodable: Codable, Identifiable {
    var id = UUID()
    let name: String
    let price: Double
    let address: String?
    let url: URL?
    var purchased: Bool
    let listGift: String
}
