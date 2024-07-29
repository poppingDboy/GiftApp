import Foundation
import Firebase

struct ListGiftCodable: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dateCreation: Date
    var dateExpiration: Date
    var profileId: String
}
