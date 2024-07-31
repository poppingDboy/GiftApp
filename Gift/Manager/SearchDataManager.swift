import Foundation
import Firebase
import FirebaseFirestore

protocol SearchRepositoryInterface {
    func fetchDataFromFirestore(completion: @escaping (Result<[ListGiftCodable], Error>) -> Void)
    func searchListByIdFromFirestore(id: UUID, completion: @escaping (Result<ListGiftCodable, Error>) -> Void)
}

class SearchRepositoryFirebase: SearchRepositoryInterface {
    private let db = Firestore.firestore()

    // Function to fetch all list gifts from Firestore
    func fetchDataFromFirestore(completion: @escaping (Result<[ListGiftCodable], Error>) -> Void) {
        // Reference to the 'listGifts' collection in Firestore
        let listsRef = db.collection("listGifts")

        // Retrieve all documents in the 'listGifts' collection
        listsRef.getDocuments { snapshot, error in
            if let error = error {
                // Return the error if the fetch fails
                completion(.failure(error))
            } else {
                // Extract and decode documents to ListGiftCodable objects
                let listGifts = snapshot?.documents.compactMap { document in
                    try? document.data(as: ListGiftCodable.self)
                } ?? []
                // Return the list of gifts on success
                completion(.success(listGifts))
            }
        }
    }

    // Function to search for a specific list gift by its ID
    func searchListByIdFromFirestore(id: UUID, completion: @escaping (Result<ListGiftCodable, Error>) -> Void) {
        // Reference to a specific document in the 'listGifts' collection by ID
        let listRef = db.collection("listGifts").document(id.uuidString)

        // Retrieve the document with the specified ID
        listRef.getDocument { document, error in
            if let error = error {
                // Return the error if the fetch fails
                completion(.failure(error))
            } else if let document = document, document.exists, let listGift = try? document.data(as: ListGiftCodable.self) {
                // Return the list gift if found and successfully decoded
                completion(.success(listGift))
            } else {
                // Return an error if the document does not exist or cannot be decoded
                completion(.failure(NSError(domain: "SearchError", code: 404, userInfo: [NSLocalizedDescriptionKey: "List not found."])))
            }
        }
    }
}

