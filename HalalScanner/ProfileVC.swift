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
    let profileCard = UIView()
    let horizontalStackForCounters = UIStackView()
    let logoutButton = UIButton()

    weak var coordinator: AppCoordinator?
    

        
    
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
        
        Firestore.firestore().collection("scans").document(uid).collection("items").getDocuments { snapshot, _ in
            let total = snapshot?.documents.count ?? 0
            let halal = snapshot?.documents.filter {
                $0.data()["isHalal"] as? Bool == true
            }.count ?? 0
            DispatchQueue.main.async {
                self.setupStatus(total: total, halal: halal, haram: total - halal)
            }
            
        }
 
    }
    
    func setupStatus(total: Int, halal: Int, haram: Int){
        let totalCard =  makeStatCard(value: "\(total)", label: "Барлығы", valueColor: .gray, labelColor: .systemGray3 , bgColor: .white)
        let halalCard = makeStatCard(value: "\(halal)", label: "Халал", valueColor: .systemGreen, labelColor: UIColor.systemGreen.withAlphaComponent(0.7), bgColor: UIColor.green.withAlphaComponent(0.1))
        let haramCard = makeStatCard(value: "\(haram)", label: "Халал емес", valueColor: .systemRed, labelColor: UIColor.systemRed.withAlphaComponent(0.7), bgColor: UIColor.red.withAlphaComponent(0.1))

        horizontalStackForCounters.axis = .horizontal
        horizontalStackForCounters.spacing = 8
        horizontalStackForCounters.distribution = .fillEqually
        horizontalStackForCounters.addArrangedSubview(totalCard)
        horizontalStackForCounters.addArrangedSubview(halalCard)
        horizontalStackForCounters.addArrangedSubview(haramCard)
        
        horizontalStackForCounters.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(horizontalStackForCounters)
        
        NSLayoutConstraint.activate([
            horizontalStackForCounters.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 20),
            horizontalStackForCounters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            horizontalStackForCounters.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            horizontalStackForCounters.heightAnchor.constraint(equalToConstant: 105)

        ])
        self.setupLogoutButton()

    }
    func makeStatCard(value: String, label: String, valueColor: UIColor, labelColor: UIColor, bgColor: UIColor, ) -> UIView {
        let card = UIView()
        card.layer.borderWidth = 1.5
        card.backgroundColor = bgColor
        card.layer.borderColor = valueColor.cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 14
      
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 32, weight: .heavy)
        valueLabel.textColor = valueColor
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(valueLabel)
        
        let labelText = UILabel()
        labelText.text = label
        labelText.font = .systemFont(ofSize: 18, weight: .medium)
        labelText.textColor = labelColor
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(labelText)
        
        NSLayoutConstraint.activate([
            
             
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            
            labelText.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            labelText.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 15)
        ])
        
        return card
    }
    
    func setupHeader() {
        
        profileCard.backgroundColor = UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1)
        profileCard.layer.cornerRadius = 16
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCard)
        
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileCard.heightAnchor.constraint(equalToConstant: 105)
        ])
        let avatar = UIView()
        avatar.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        avatar.layer.cornerRadius = 33
        avatar.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(avatar)
        
        
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: profileCard.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 66),
            avatar.heightAnchor.constraint(equalToConstant: 66)
        ])
        
        let email = Auth.auth().currentUser?.email ?? "?"
        avatarLabel.text = String(email.prefix(1)).uppercased()
        avatarLabel.font = .systemFont(ofSize: 25, weight: .bold)
        avatarLabel.textColor = .white
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatar.addSubview(avatarLabel)
        
        NSLayoutConstraint.activate([
            avatarLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor)
        ])
        
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor  = .white
        nameLabel.text = "Пайдаланушы"

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(nameLabel)
        
        let emailLabel = UILabel()
        emailLabel.text = Auth.auth().currentUser?.email ?? "?"
        emailLabel.textColor = .white.withAlphaComponent(0.8)
        emailLabel.font = .systemFont(ofSize: 20)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 12),
            
            emailLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
      
        ])
        
    
        roleBage.backgroundColor = .white.withAlphaComponent(0.2)
        roleBage.layer.cornerRadius = 8
        roleBage.textColor = .white
        roleBage.layer.masksToBounds = true
        roleBage.text = " user "
        roleBage.font = .systemFont(ofSize: 17, weight: .regular)
        roleBage.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(roleBage)
        
        NSLayoutConstraint.activate([
            roleBage.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20),
            roleBage.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6)
        ])
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Шығу", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        logoutButton.layer.cornerRadius = 12
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        
    }
    func setupLogoutButton() {
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: horizontalStackForCounters.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 68)
        ])
    }
    @objc func logoutTapped() {
        coordinator?.logout()
    }
    
    
    
}
