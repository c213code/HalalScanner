//
//  AdminVIewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 04.04.2026.
//

import UIKit
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
        isLoading = true
        let group = DispatchGroup()
        
        group.enter()
        Firestore.firestore().collection("users").getDocuments { [weak self] snapshot, _ in
            self?.totalUsers = snapshot?.documents.count ?? 0
            group.leave()
        }
        
        group.enter()
        Firestore.firestore().collection("ratings")
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, _ in
                let docs = snapshot?.documents ?? []
                
                let allStars = docs.compactMap { $0.data()["stars"] as? Int}
                let avg = allStars.isEmpty ? 0.0 : Double(allStars.reduce(0, +)) / Double(allStars.count)
                self?.avarageRating = (avg*10).rounded() / 10
                
                self?.recentRatings = docs.prefix(5).map { doc in
                    var data = doc.data()
                    data["documentId"] = doc.documentID
                    return data
                }
                group.leave()
            }
        group.enter()
        Firestore.firestore().collection("feedbac")
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, _ in
                let docs = snapshot?.documents ?? []
                self?.totalFeedbacks = docs.count
                self?.recentFeedbacks = docs.prefix(5).map { doc in
                    var data = doc.data()
                    data["documentId"] = doc.documentID
                    return data
                }
                group.leave()
                group.notify(queue: .main) { [weak self] in
                    self?.isLoading = false
                }
            }

    }
}

