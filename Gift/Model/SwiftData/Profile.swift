import Foundation
import SwiftData
import Firebase

@Model
class Profile: Identifiable {
    let id = UUID()
    var emailAddress: String = ""
    var password: String = ""
    var fullName: String = ""
    var phoneNumber: String = ""

    init(id: UUID = UUID(), emailAddress: String, password: String, fullName: String, phoneNumber: String) {
        self.id = id
        self.emailAddress = emailAddress
        self.password = password
        self.fullName = fullName
        self.phoneNumber = phoneNumber
    }

    // Mapper vers ProfileCodable
    func toCodable() -> ProfileCodable {
        return ProfileCodable(
            id: id,
            emailAddress: emailAddress,
            password: password,
            fullName: fullName,
            phoneNumber: phoneNumber
        )
    }

    // Mapper depuis ProfileCodable
    convenience init(from codable: ProfileCodable) {
        self.init(
            id: codable.id,
            emailAddress: codable.emailAddress,
            password: codable.password,
            fullName: codable.fullName,
            phoneNumber: codable.phoneNumber
        )
    }
}
