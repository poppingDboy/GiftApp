import Foundation
import Firebase

struct ProfileCodable: Codable {
    var id: String
    var emailAddress: String
    var password: String
    var fullName: String
    var phoneNumber: String
}
