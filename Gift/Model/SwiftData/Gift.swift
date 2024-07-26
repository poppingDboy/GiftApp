import Foundation
import SwiftData
import Firebase

@Model
class Gift: Identifiable, Hashable, ObservableObject {
    var id: UUID
    let name: String
    let price: Double
    let address: String?
    let url: URL?
    var purchased: Bool
    let listGift: String

    init(id: UUID = UUID(), name: String, price: Double, address: String? = nil, url: URL? = nil, purchased: Bool = false, listGift: String) {
        self.id = id
        self.name = name
        self.price = price
        self.address = address
        self.url = url
        self.purchased = purchased
        self.listGift = listGift
    }

    static func == (lhs: Gift, rhs: Gift) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }


    // Mapper vers GiftCodable
    func toCodable() -> GiftCodable {
        return GiftCodable(
            id: id,
            name: name,
            price: price,
            address: address,
            url: url,
            purchased: purchased,
            listGift: listGift
        )
    }

    // Mapper depuis GiftCodable
    convenience init(from codable: GiftCodable) {
        self.init(
            name: codable.name,
            price: codable.price,
            address: codable.address,
            url: codable.url,
            purchased: codable.purchased,
            listGift: codable.listGift
        )
        self.id = codable.id
    }
}

