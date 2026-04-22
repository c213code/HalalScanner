//
//  ScannerViewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//
import Foundation
import Combine
import FirebaseAuth
import Firebase

class ScannerViewModel {
    
    @Published var statusText = "Preparing scanner..."
    @Published var isReady = false
    @Published var isDetecting = false
    @Published var detectedProduct: (Product, Int)? = nil
    
    var cancellables = Set<AnyCancellable>()
    
    func preloadIfNeeded() {
        if ModelManager.shared.isReady {
            isReady = true
            statusText = "Ready to scan ✅"
        }
        else {
            statusText = "Preparing scanner..."
            DispatchQueue.global(qos: .userInitiated).async {
                ModelManager.shared.preload { [weak self] in
                    DispatchQueue.main.async {
                        self?.isReady = ModelManager.shared.isReady
                        self?.statusText = ModelManager.shared.isReady ? "Ready to scan ✅" : "Model load failed"
                    }
                }
            }
        }
    }
    
    
    func beginDetection() {
        guard !isDetecting else { return }
        isDetecting = true
        statusText = "Іздеуде..."
    }

    
    func handleResult(label: String?, confidence: Int) {
        isDetecting = false
        if let label = label, let product = ProductCatalog.products[label] {
            statusText = "Табылды: \(product.emoji) \(product.name) \(confidence)%"
            autoSave(product: product, confidence: confidence)
            detectedProduct = (product, confidence)
        } else {
            statusText = "Тағам табылмады ❌"
            detectedProduct = nil
        }
    }
    
    func autoSave(product: Product, confidence: Int) {
       guard let uid = Auth.auth().currentUser?.uid else { return }
        var data: [String : Any] = [
            "name": product.name,
            "emoji": product.emoji,
            "isHalal": product.halalStatus == .halal,
            "confidence": confidence,
            "category": product.category,
            "calories": product.calories,
            "date": Date()
        ]
        Firestore.firestore()
            .collection("scans")
            .document(uid)
            .collection("items")
            .addDocument(data: data) { _ in
                print("АВТОСОХРАНЕНО!")

        }
    }
    
    
}
