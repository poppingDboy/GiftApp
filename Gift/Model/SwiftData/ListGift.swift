import Foundation
import SwiftData
import Firebase

@Model
class ListGift: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let dateCreation: Date
    let dateExpiration: Date
    let profileId: String
    var gifts: [Gift] = []

    init(name: String, dateCreation: Date, dateExpiration: Date, profileId: String) {
        self.name = name
        self.dateCreation = dateCreation
        self.dateExpiration = dateExpiration
        self.profileId = profileId
    }

    func addGift(_ gift: Gift) {
        gifts.append(gift)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ListGift, rhs: ListGift) -> Bool {
        return lhs.id == rhs.id
    }

    // Mapper vers ListGiftCodable
    func toCodable() -> ListGiftCodable {
        return ListGiftCodable(
            id: id,
            name: name,
            dateCreation: dateCreation,
            dateExpiration: dateExpiration,
            profileId: profileId
        )
    }

    // Mapper depuis ListGiftCodable
    convenience init(from codable: ListGiftCodable) {
        self.init(
            name: codable.name,
            dateCreation: codable.dateCreation,
            dateExpiration: codable.dateExpiration,
            profileId: codable.profileId
        )
        self.id = codable.id
    }
}
