//
//  ProductModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 08.03.2026.
//

import Foundation

struct Product {

    let name: String
    let emoji: String
    let isHalal: Bool
    let category: String
    let calories: Int
 
   
}


struct ProductCatalog {

    static let products: [String: Product] = [

        "rollton": Product(
            name: "Роллтон",
            emoji: "🍜",
            isHalal: true,
            category: "Жылдам тамақ",
            calories: 450
        ),

        "flint": Product(
            name: "Flint",
            emoji: "🥨",
            isHalal: false,
            category: "Снеки",
            calories: 365
        ),

        "dizzy": Product(
            name: "Dizzy",
            emoji: "🥤",
            isHalal: true,
            category: "Сусын",
            calories: 50
        )
    ]
}
