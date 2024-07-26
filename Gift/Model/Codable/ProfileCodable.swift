import Foundation
import Firebase

struct ProfileCodable: Codable {
    let id: UUID
    var emailAddress: String
    var password: String
    var fullName: String
    var phoneNumber: String
}
