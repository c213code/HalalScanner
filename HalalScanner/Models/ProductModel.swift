//
//  ProductModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 08.03.2026.
//

import Foundation

enum HalalStatus {
    case halal
    case haram
    case doubtful
}

struct Product {

    let name: String
    let emoji: String
    let halalStatus: HalalStatus
    let category: String
    let calories: Int
    let haramItem: String?

    init(name: String, emoji: String, halalStatus: HalalStatus,
         category: String, calories: Int, haramItem: String? = nil) {
        self.name        = name
        self.emoji       = emoji
        self.halalStatus = halalStatus
        self.category    = category
        self.calories    = calories
        self.haramItem   = haramItem
    }

    var isHalal: Bool {
        return halalStatus == .halal
    }
    
 
   
}


struct ProductCatalog {

    static let products: [String: Product] = [

        "rollton": Product(
            name: "Роллтон",
            emoji: "🍜",
            halalStatus: .halal,
            category: "Жылдам тамақ",
            calories: 450
        ),

        "dizzy": Product(
            name: "Dizzy",
            emoji: "🥤",
            halalStatus: .halal,
            category: "Сусын",
            calories: 50
        ),
        "bal qymyz": Product(
            name: "Бал қымыз",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "chudo": Product(
            name: "Молочный коктейль Чудо",
            emoji: "🥤",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "danone packet": Product(
            name: "Живой йогурт Danone",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "prost syrok": Product(
            name: "Сырок Простоквашино",
            emoji: "🍬",
            halalStatus: .haram,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "krest": Product(
            name: "Масло Крестьянское 72,5%",
            emoji: "🧈",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "shino": Product(
            name: "Шин-Лайн масло 72.5%",
            emoji: "🧈",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "volo": Product(
            name: "Вологодское масло 82.5%",
            emoji: "🧈",
            halalStatus: .haram,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "zhailau": Product(
            name: "Масло Жайлау 72,5%",
            emoji: "🧈",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "zhailau kaimak": Product(
            name: "Сметана Жайлау",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "xox": Product(
            name: "Сметана Хохлушка 20%",
            emoji: "🥛",
            halalStatus: .haram,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "sme": Product(
            name: "Сметана Умут 20%",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "president kaimak": Product(
            name: "Сметана Президент 20%",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "prost kaimak": Product(
            name: "Сметана Простоквашино",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "zhel sgu": Product(
            name: "Сгущенка 3 желания",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "burenka": Product(
            name: "Сгущенка Буренка",
            emoji: "🥛",
            halalStatus: .doubtful,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "derevenskoe": Product(
            name: "Молоко Деревенское",
            emoji: "🥛",
            halalStatus: .doubtful,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "miloko": Product(
            name: "Молоко Милоко",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),
        "shadr": Product(
            name: "Молоко Шадринское",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "aya moloko": Product(
            name: "Молоко Ая",
            emoji: "🥛",
            halalStatus: .doubtful,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "petr kefir": Product(
            name: "Кефир Петропавловский",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),
        "petr moloko": Product(
            name: "Молоко Петропавловское",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),
        

        "natige": Product(
            name: "Живой йогурт Natige",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "rastishka": Product(
            name: "Йогурт Растишка",
            emoji: "🍶",
            halalStatus: .haram,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "tan": Product(
            name: "Тан",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),
        "shin moloko": Product(
            name: "Молоко Шиновское",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "adal": Product(
            name: "Молоко Adal",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "moe": Product(
            name: "Молоко Моё",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "domash": Product(
            name: "Смета Домашняя Маслёнково",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "trad": Product(
            name: "Смета Традиционная Маслёнково",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "maslenko_dessert": Product(
            name: "Масленково десертная масса",
            emoji: "🍨",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 450
        ),

        "emir": Product(
            name: "Сыр Эмир",
            emoji: "🧀",
            halalStatus: .haram,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "hansky": Product(
            name: "Сыр Ханский",
            emoji: "🧀",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 50
        ),

        "aktiviai": Product(
            name: "Йогурт Активиа",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 450
        ),

        "bios": Product(
            name: "Йогурт Био-С",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "food master kefir": Product(
            name: "Кефир Food Master",
            emoji: "🥛",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 50
        ),

        "slivki": Product(
            name: "Сливки Чудское озеро",
            emoji: "🥛",
            halalStatus: .doubtful,
            category: "Сүтті өнімдер",
            calories: 450
        ),

        "petro slivki": Product(
            name: "Сливки Петропавловские",
            emoji: "🥛",
            halalStatus: .haram,
            category: "Сүтті өнімдер",
            calories: 365
        ),

        "lubimka yogurt": Product(
            name: "Йогурт Любимка",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 50
        ),

        "Danone yog": Product(
            name: "Живой йогурт Danone",
            emoji: "🍶",
            halalStatus: .halal,
            category: "Сүтті өнімдер",
            calories: 365
        ),
        "snickers": Product(
            name: "Сникерс",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "bueno": Product(
            name: "Буено Киндер",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "twix": Product(
            name: "Твикс батончик",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "super": Product(
            name: "Супер Контик",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "belvita": Product(
            name: "Бельвита печенье",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
        "chocopie": Product(
            name: "Чоко Пай",
            emoji: "🍫",
            halalStatus: .haram,
            category: "Тәттілер",
            calories: 365,
            haramItem: "сорбитан тристеарат, желатин, e319"
        ),
         "halley": Product(
            name: "Халлей Ulker",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "bounty": Product(
            name: "Баунти",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "kinder": Product(
            name: "Киндер шоколад",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "alpen": Product(
            name: "Альпен Голд",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "kaz": Product(
            name: "Казахстан шоколад",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "yash": Product(
            name: "Яшкино вафли",
            emoji: "🍫",
            halalStatus: .doubtful,
            category: "Тәттілер",
            calories: 365,
            haramItem: "сыворотка"
        ),
         "merci": Product(
            name: "Мерси",
            emoji: "🍫",
            halalStatus: .halal,
            category: "Тәттілер",
            calories: 365
        ),
         "mini": Product(
            name: "Мини-Рулеты Яшкино",
            emoji: "🍫",
            halalStatus: .doubtful,
            category: "Тәттілер",
            calories: 365,
            haramItem: "кармин, сыворотка"

        ),
         "bondi": Product(
            name: "Бонди Детское печенье",
            emoji: "🍫",
            halalStatus: .doubtful,
            category: "Тәттілер",
            calories: 365,
            haramItem: "сыворотка"
        ),
         "grizzly": Product(
            name: "Чипсы Гриззли",
            emoji: "🥨",
            halalStatus: .halal,
            category: "Снэки",
            calories: 365
        ),
         "grenki": Product(
            name: "Гренки",
            emoji: "🥨",
            halalStatus: .halal,
            category: "Снэки",
            calories: 365
        ),
         "flint": Product(
            name: "Флинт сухарики",
            emoji: "🥨",
            halalStatus: .halal,
            category: "Снэки",
            calories: 365
        ),
         "doritos": Product(
            name: "Чипсы Доритос",
            emoji: "🥨",
            halalStatus: .doubtful,
            category: "Снэки",
            calories: 365,
            haramItem: "инозинат натрия"
        ),
         "lays": Product(
            name: "Чипсы Lays",
            emoji: "🥨",
            halalStatus: .doubtful,
            category: "Снэки",
            calories: 365,
            haramItem: "ракообразные добавки"
        ),
    ]
}
