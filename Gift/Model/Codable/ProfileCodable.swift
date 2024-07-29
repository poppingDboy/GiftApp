import Foundation
import Firebase

struct ProfileCodable: Identifiable, Codable {
    var id = UUID()
    var emailAddress: String
    var password: String
    var fullName: String
    var phoneNumber: String
}
