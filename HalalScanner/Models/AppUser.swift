    //
//  AppUser.swift
//   HalalScanner
//
//  Created by Yerasyl Toleubek on 23.03.2026.
//

import UIKit

enum UserRole: String {
    case user = "user"
    case admin = "admin"
}

struct AppUser {
    let uid: String
    let email: String
    let name: String
    let role: UserRole
        
    init?(uid: String, data: [String: Any]){
        guard let email = data["email"] as? String else { return nil }
        
        
        self.uid = uid
        self.email = email
        self.name = data["name"] as? String ?? "Пайдаланушы"
        self.role = UserRole(rawValue: data["role"] as? String ?? "") ?? .user
    }
}
