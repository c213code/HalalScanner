//
//  HistoryViewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 28.03.2026.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class HistoryViewModel : ObservableObject {
    @Published var scans: [[String: Any]] = []
    @Published var isLoading = false
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchScans() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        Firestore.firestore()
            .collection("scans")
            .document(userId)
            .collection("items")
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, error in
                self?.isLoading = false
                self?.scans = snapshot?.documents.map { $0.data() } ?? []
            }
        
    }
}
