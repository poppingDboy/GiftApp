import Foundation
import Firebase

// RestGift
struct GiftCodable: Codable {
    let id: UUID
    let name: String
    let price: Double
    let address: String?
    let url: URL?
    var purchased: Bool
    let listGift: String
}
