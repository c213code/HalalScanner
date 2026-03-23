//
//  ProfileVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 23.03.2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class ProfileVC: UIViewController {
    
    let avatarLabel = UILabel()
    let nameLabel = UILabel()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Профиль"
        setupHeader()
    }
    
    func setupHeader() {
        let card = UIView()
        card.backgroundColor = UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1)
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            card.heightAnchor.constraint(equalToConstant: 90)
        ])
        let avatar = UIView()
        avatar.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        avatar.layer.cornerRadius = 28
        avatar.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(avatar)
        
        
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        let email = Auth.auth().currentUser?.email ?? "?"
        avatarLabel.text = String(email.prefix(1)).uppercased()
        avatarLabel.font = .systemFont(ofSize: 22, weight: .bold)
        avatarLabel.textColor = .white
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatar.addSubview(avatarLabel)
        
        NSLayoutConstraint.activate([
            avatarLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])
        
        nameLabel.text = "Пайдаланушы"
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.textColor  = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(nameLabel)
        
        let emailLabel = UILabel()
        emailLabel.text = Auth.auth().currentUser?.email ?? "?"
        emailLabel.textColor = .white.withAlphaComponent(0.8)
        emailLabel.font = .systemFont(ofSize: 12)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 4),
            
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 12),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
                    
        ])
    }
    
}
