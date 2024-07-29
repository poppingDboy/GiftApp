//import Foundation
//import SwiftData
//import Firebase
//
//protocol Data {
//    func fetchDataFromFirestore()
//    func searchListByIdFromFirestore(id: UUID)
//
//    func fetchUserProfile()
//
//    //
//    func addListGift(name: String, expirationDate: Date)
//
//    func addGift(name: String, price: Double, address: String?, url: String?, listGiftID: String)
//
//    func fetchGifts()
//
//    func fetchListGiftDetails(listGiftId: UUID)
//    func removeGift(gift: Gift, from listGift: ListGift)
//    func purchased()
//
//    //
//
//    func saveProfileToFirestore(profile: Profile, completion: @escaping (Error?) -> Void)
//    func fetchProfileFromFirestore(profileId: UUID, completion: @escaping (ProfileCodable?) -> Void)
//}
//
//enum DataError: Error {
//    case defaultError
//}
//
//final class DataManager {
//
//}
//
//final class DataManagerMock: Data {
//
//}
