//
//  ScannerViewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//
import Foundation
import UIKit
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
    
    func detect(image: UIImage) {
        guard !isDetecting else { return }
        
        let foodModel = ModelManager.shared.getModel(named: "food")
        let dairyModel = ModelManager.shared.getModel(named: "dairy")
        
        guard foodModel != nil && dairyModel != nil else {
            statusText = "Model not loaded"
            return
        }
        
        isDetecting = true
        statusText = "Searching..."
        
        var bestLabel: String?
        var bestConfidence: Int = 0
        let group = DispatchGroup()

        for model in [foodModel, dairyModel].compactMap({ $0 }) {
            group.enter()
            
            model.detect(image: image) { predictions, _ in
                if let first = predictions?.first {
                    let values = first.getValues()
                    let label = (values["class"] as? String ?? "").lowercased()
                    let confidence = Int(((values["confidence"] as? NSNumber)?.doubleValue ?? 0) * 100)
                    if confidence > bestConfidence{
                        bestLabel = label
                        bestConfidence = confidence
                    }
                }
                group.leave()
            }
          
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isDetecting = false
            if let label = bestLabel, let product = ProductCatalog.products[label] {
                self.statusText = "Detected: \(product.emoji) \(product.name) \(bestConfidence)%"
                self.autoSave(product: product, confidence: bestConfidence)
                self.detectedProduct = (product, bestConfidence)
            } else {
                self.statusText = "No Food Detected ❌"
                self.detectedProduct = nil
            }
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
