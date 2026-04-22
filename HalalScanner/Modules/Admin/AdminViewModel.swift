//
//  AdminVIewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 04.04.2026.
//

import Foundation
import Combine
import FirebaseFirestore

class AdminViewModel: ObservableObject {
    @Published var recentRatings: [[String: Any]] = []
    @Published var recentFeedbacks: [[String: Any]] = []
    @Published var isLoading = false
    @Published var avarageRating: Double = 0.0
    @Published var totalUsers: Int = 0
    @Published var totalFeedbacks: Int = 0

    var cancellables = Set<AnyCancellable>()

    func fetchData() {
        DispatchQueue.main.async { self.isLoading = true }
        let group = DispatchGroup()

        
        group.enter()
        Firestore.firestore().collection("users").getDocuments { [weak self] snapshot, _ in
            let count = snapshot?.documents.count ?? 0
            DispatchQueue.main.async { self?.totalUsers = count }
            group.leave()
        }

        
        group.enter()
        Firestore.firestore().collection("ratings")
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, _ in
                let docs = snapshot?.documents ?? []
                let allStars = docs.compactMap { $0.data()["stars"] as? Int }
                let avg = allStars.isEmpty ? 0.0 : Double(allStars.reduce(0, +)) / Double(allStars.count)
                let rounded = (avg * 10).rounded() / 10
                let recent = docs.prefix(5).map { doc -> [String: Any] in
                    var data = doc.data()
                    data["documentId"] = doc.documentID
                    return data
                }
                DispatchQueue.main.async {
                    self?.avarageRating = rounded
                    self?.recentRatings = recent
                }
                group.leave()
            }

        
        group.enter()
        Firestore.firestore().collection("feedback")
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, _ in
                let docs = snapshot?.documents ?? []
                let recent = docs.prefix(5).map { doc -> [String: Any] in
                    var data = doc.data()
                    data["documentId"] = doc.documentID
                    return data
                }
                DispatchQueue.main.async {
                    self?.totalFeedbacks = docs.count
                    self?.recentFeedbacks = recent
                }
                group.leave()
            }

        
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
        }
    }
}
