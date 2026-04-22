import Foundation
import Firebase
import Combine
import FirebaseAuth

class FavoritesViewModel : ObservableObject {
    @Published var favorites: [[String: Any]] = []
    @Published var isLoading = false

    var cancellables = Set<AnyCancellable>()

    func fetchScans() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true

        Firestore.firestore()
            .collection("favorites")
            .document(userId)
            .collection("items")
            .order(by: "savedAt", descending: true)
            .getDocuments { [weak self] snapshot, _ in
                let result = snapshot?.documents.map { doc -> [String: Any] in
                    var data = doc.data()
                    data["documentId"] = doc.documentID
                    return data
                } ?? []
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.favorites = result
                }
            }
    }
}
