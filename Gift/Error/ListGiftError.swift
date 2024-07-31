import Foundation

enum ListGiftError: Error {
    case defaultError
    case saveError
    case fetchError
    case fetchNoDocumentError
    case deleteError
}
