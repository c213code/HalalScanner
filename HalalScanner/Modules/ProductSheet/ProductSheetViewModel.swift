//
//  ProductSheetViewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProductSheetViewModel {
    let product: Product
    let confidence: Int
    
    init(product: Product, confidence: Int) {
        self.product = product
        self.confidence = confidence
    }
    
    var emoji: String { product.emoji }
    var name: String { product.name }
    var category: String { product.category }
    var caloriesText: String { "\(product.calories)" }
    var confidenceText: String { "\(confidence)%" }
    
    var halalTitle: String {
        switch product.halalStatus {
            case .halal:
              return "Halal"
          case .haram:
              return "Not Halal"
          case .doubtful:
              return "Күмәнді"
          }
    }
    var statusText: String {
          switch product.halalStatus {
          case .halal:
              return "Халал"
          case .haram:
              return "Халал емес"
          case .doubtful:
              return "Күмәнді"
          }
      }

      var halalTextColor: UIColor {
          switch product.halalStatus {
          case .halal:
              return .systemGreen
          case .haram:
              return .systemRed
          case .doubtful:
              return .systemOrange
          }
      }

      var halalBackgroundColor: UIColor {
          switch product.halalStatus {
          case .halal:
              return UIColor.green.withAlphaComponent(0.3)
          case .haram:
              return UIColor.red.withAlphaComponent(0.3)
          case .doubtful:
              return UIColor.orange.withAlphaComponent(0.3)
          }
      }

      var emojiBackgroundColor: UIColor {
          switch product.halalStatus {
          case .halal:
              return .appCardGreen
          case .haram:
              return .appCardRed
          case .doubtful:
              return UIColor.systemOrange.withAlphaComponent(0.2)
          }
      }

      var statusTextColor: UIColor {
          switch product.halalStatus {
          case .halal:
              return UIColor.appGreen
          case .haram:
              return .systemRed
          case .doubtful:
              return .systemOrange
          }
      }
    var isHalal: Bool {
        switch product.halalStatus {
        case .halal:
            return true
        case .haram:
            return false
        case .doubtful:
            return false
        }
    }
    
    
    func saveToFavorites(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        Firestore.firestore()
            .collection("favorites")
            .document(userId)
            .collection("items")
            .addDocument(data: makeFavoriteData()) { error in
                if let error = error {
                    print("Ошибка:", error.localizedDescription)
                    completion(false)
                } else {
                    print("СОХРАНЕНО!")
                    completion(true)
                }
            }
    }
    private func makeFavoriteData() -> [String: Any] {
           [
               "name": product.name,
               "emoji": product.emoji,
               "isHalal": product.isHalal,
               "confidence": confidence,
               "category": product.category,
               "calories": product.calories,
               "date": Date(),
               "savedAt": Date()
           ]
       }

    

    
}
