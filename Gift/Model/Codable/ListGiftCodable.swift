import Foundation
import Firebase

struct ListGiftCodable: Codable {
    var id: UUID
    var name: String
    var dateCreation: Date
    var dateExpiration: Date
    var profileId: String
}
