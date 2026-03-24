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
    let roleBage = UILabel()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Профиль"
        loadUserData()
        setupHeader()
    }
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument{ snapshot, error in
            guard let data = snapshot?.data() else { return }
            let name = data["name"] as? String ?? "Пайдаланушы"
            let role = data["role"] as? String ?? "user"
                    
            DispatchQueue.main.async {
                self.roleBage.text = " \(role) "
                self.nameLabel.text = name
            }
        }
        
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
            
            emailLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
      
        ])
        
    
        roleBage.backgroundColor = .white.withAlphaComponent(0.2)
        roleBage.layer.cornerRadius = 8
        roleBage.textColor = .white
        roleBage.layer.masksToBounds = true
        roleBage.text = " user "
        roleBage.font = .systemFont(ofSize: 13, weight: .regular)
        roleBage.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(roleBage)
        
        NSLayoutConstraint.activate([
            roleBage.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),
            roleBage.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4)
        ])
        
        let logoutButton = UIButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Шығу", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        logoutButton.layer.cornerRadius = 12
        logoutButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 24),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        
        
    }
    @objc func logoutTapped() {
        try? Auth.auth().signOut()
        let authVC = AuthVC()
        let nav = UINavigationController(rootViewController: authVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
    
}
