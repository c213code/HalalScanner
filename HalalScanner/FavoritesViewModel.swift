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
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, error in
                self?.isLoading = false
                self?.favorites = snapshot?.documents.map { $0.data() } ?? []
            }
        
    }
}
