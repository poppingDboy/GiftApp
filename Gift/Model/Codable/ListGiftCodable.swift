import Foundation
import Firebase

struct ListGiftCodable: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var dateCreation: Date
    var dateExpiration: Date
    var profileId: String

    static func ==(lhs: ListGiftCodable, rhs: ListGiftCodable) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.dateCreation == rhs.dateCreation &&
        lhs.dateExpiration == rhs.dateExpiration &&
        lhs.profileId == rhs.profileId
    }
}
