//
//  ProfileView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit
import FirebaseAuth


class ProfileView : UIView {
    let avatarLabel = UILabel()
    let nameLabel = UILabel()
    let roleBage = UILabel()
    let profileCard = UIView()
    let horizontalStackForCounters = UIStackView()
    let logoutButton = UIButton()
    let progressCard = UIView()
    let progressBar = UIView()
    let progressLabel = UILabel()
    let progressTitleLabel = UILabel()
    var progressWidthConstraint: NSLayoutConstraint?
    
    let accountCard = UIView()
    let editNameButton = UIButton()
    let editPasswordButton = UIButton()
    
    let supportCard = UIView()
    let ratingButton = UIButton()
    let feedbackButton = UIButton()
    
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
        setupLogoutButton()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setupStatus(total: Int, halal: Int, haram: Int){
        horizontalStackForCounters.arrangedSubviews.forEach { $0.removeFromSuperview() }

        
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

    }
    func makeStatCard(value: String, label: String, valueColor: UIColor, labelColor: UIColor, bgColor: UIColor) -> UIView {
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
        
        profileCard.backgroundColor = UIColor.appGreen
        profileCard.layer.cornerRadius = 16
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileCard)
        
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            profileCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            profileCard.heightAnchor.constraint(equalToConstant: 105)
        ])
        let avatar = UIView()
        avatar.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        avatar.layer.cornerRadius = 33
        avatar.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(avatar)
        
        addSubview(horizontalStackForCounters)
        
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
        
        NSLayoutConstraint.activate([
            horizontalStackForCounters.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 20),
            horizontalStackForCounters.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackForCounters.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackForCounters.heightAnchor.constraint(equalToConstant: 105)

        ])
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Шығу", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        logoutButton.layer.cornerRadius = 12
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        addSubview(logoutButton)
        
        setupProgressCard()
        setupAccountCard(below: progressCard)
        createSupportCard(below: accountCard)
        
        
    }
    func setupLogoutButton() {
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: supportCard.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 68)
        ])
    }
    
    func setupProgressCard() {
        progressCard.backgroundColor = .white
        progressCard.layer.cornerRadius = 14
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressCard)
        
        NSLayoutConstraint.activate([
            progressCard.topAnchor.constraint(equalTo: horizontalStackForCounters.bottomAnchor, constant: 14),
            progressCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressCard.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        progressTitleLabel.text = "Халал пайызы"
        progressTitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        progressTitleLabel.textColor = .systemGray
        progressTitleLabel.textAlignment = .left
        progressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressCard.addSubview(progressTitleLabel)
        
        progressLabel.text = "0%"
        progressLabel.font = .systemFont(ofSize: 13, weight: .bold)
        progressLabel.textColor = UIColor.appGreen
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressCard.addSubview(progressLabel)
        
        let trackView = UIView()
        trackView.backgroundColor = .systemGray5
        trackView.layer.cornerRadius = 5
        trackView.translatesAutoresizingMaskIntoConstraints = false
        progressCard.addSubview(trackView)
        
        progressBar.backgroundColor = UIColor.appGreen
        progressBar.layer.cornerRadius = 5
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        trackView.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressTitleLabel.topAnchor.constraint(equalTo: progressCard.topAnchor, constant: 14),
            progressTitleLabel.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 16),
            
            progressLabel.centerYAnchor.constraint(equalTo: progressTitleLabel.centerYAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: progressCard.trailingAnchor, constant: -16),
            
            trackView.topAnchor.constraint(equalTo: progressTitleLabel.bottomAnchor, constant: 10),
            trackView.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 16),
            trackView.trailingAnchor.constraint(equalTo: progressCard.trailingAnchor, constant: -16),
            trackView.heightAnchor.constraint(equalToConstant: 10),
            
            progressBar.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: trackView.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: trackView.bottomAnchor),
            
            
        ])
        progressWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressWidthConstraint?.isActive = true
        
        
    }
    
    func setupAccountCard(below anchorView: UIView) {
        let sectionLabel = UILabel()
        sectionLabel.text = "Аккаyнт"
        sectionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        sectionLabel.textColor = .systemGray
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionLabel)
        
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: anchorView.bottomAnchor , constant: 20),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        accountCard.backgroundColor = .white
        accountCard.layer.cornerRadius = 14
        accountCard.clipsToBounds = true
        accountCard.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accountCard)
        
        NSLayoutConstraint.activate([
            accountCard.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 8),
            accountCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            accountCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            accountCard.heightAnchor.constraint(equalToConstant: 124)
        ])
        
        let nameRow = makeAccountRow(title: "Атымды өзгерту", icon: "✏️", iconBackgroundColor: UIColor.appGreen.withAlphaComponent(0.15), button: editNameButton)
        let passwordRow = makeAccountRow(title: "Құпия сөзді өзгерту", icon: "🔒", iconBackgroundColor: UIColor.systemBlue.withAlphaComponent(0.15), button: editPasswordButton)
        
        
        let devider = UIView()
        devider.backgroundColor = .systemGray5
        devider.translatesAutoresizingMaskIntoConstraints = false
        
        accountCard.addSubview(nameRow)
        accountCard.addSubview(devider)
        accountCard.addSubview(passwordRow)
        
        
        NSLayoutConstraint.activate([
            nameRow.topAnchor.constraint(equalTo: accountCard.topAnchor),
            nameRow.leadingAnchor.constraint(equalTo: accountCard.leadingAnchor),
            nameRow.trailingAnchor.constraint(equalTo: accountCard.trailingAnchor),
            nameRow.heightAnchor.constraint(equalToConstant: 62),
            passwordRow.heightAnchor.constraint(equalToConstant: 62),
            
            
            devider.topAnchor.constraint(equalTo: nameRow.bottomAnchor),
            devider.leadingAnchor.constraint(equalTo: accountCard.leadingAnchor, constant: 14),
            devider.trailingAnchor.constraint(equalTo: accountCard.trailingAnchor),
            devider.heightAnchor.constraint(equalToConstant: 0.5),
            
            passwordRow.topAnchor.constraint(equalTo: devider.bottomAnchor),
            passwordRow.leadingAnchor.constraint(equalTo: accountCard.leadingAnchor),
            passwordRow.trailingAnchor.constraint(equalTo: accountCard.trailingAnchor),
            passwordRow.bottomAnchor.constraint(equalTo: accountCard.bottomAnchor)
            
            
        ])
        
        
        
    }
    
    func createSupportCard(below anchorView: UIView) {
        let sectionLabel = UILabel()
        sectionLabel.text = "Қолдау"
        sectionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        sectionLabel.textColor = .systemGray
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionLabel)
        
        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: anchorView.bottomAnchor , constant: 20),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        supportCard.backgroundColor = .white
        supportCard.layer.cornerRadius = 14
        supportCard.clipsToBounds = true
        supportCard.translatesAutoresizingMaskIntoConstraints = false
        addSubview(supportCard)
        
        NSLayoutConstraint.activate([
            supportCard.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 8),
            supportCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            supportCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            supportCard.heightAnchor.constraint(equalToConstant: 124)
        ])
        
        let ratingRow = makeAccountRow(title: "Бағалау", icon: "⭐️", iconBackgroundColor: UIColor.blue.withAlphaComponent(0.15), button: ratingButton)
        let feedbackRow = makeAccountRow(title: "Байланыс/Сұрақ", icon: "❓", iconBackgroundColor: UIColor.red.withAlphaComponent(0.15), button: feedbackButton)
        
        let devider = UIView()
        devider.backgroundColor = .systemGray5
        devider.translatesAutoresizingMaskIntoConstraints = false
        
        supportCard.addSubview(ratingRow)
        supportCard.addSubview(devider)
        supportCard.addSubview(feedbackRow)
        
        
        NSLayoutConstraint.activate([
            ratingRow.topAnchor.constraint(equalTo: supportCard.topAnchor),
            ratingRow.leadingAnchor.constraint(equalTo: supportCard.leadingAnchor),
            ratingRow.trailingAnchor.constraint(equalTo: supportCard.trailingAnchor),
            ratingRow.heightAnchor.constraint(equalToConstant: 62),
            feedbackRow.heightAnchor.constraint(equalToConstant: 62),
            
            
            devider.topAnchor.constraint(equalTo: ratingRow.bottomAnchor),
            devider.leadingAnchor.constraint(equalTo: supportCard.leadingAnchor, constant: 14),
            devider.trailingAnchor.constraint(equalTo: supportCard.trailingAnchor),
            devider.heightAnchor.constraint(equalToConstant: 0.5),
            
            feedbackRow.topAnchor.constraint(equalTo: devider.bottomAnchor),
            feedbackRow.leadingAnchor.constraint(equalTo: supportCard.leadingAnchor),
            feedbackRow.trailingAnchor.constraint(equalTo: supportCard.trailingAnchor),
            feedbackRow.bottomAnchor.constraint(equalTo: supportCard.bottomAnchor)
            
            
        ])
        

    }
    
    func makeAccountRow(title: String, icon: String, iconBackgroundColor: UIColor, button: UIButton) -> UIView{
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = iconBackgroundColor
        iconContainer.layer.cornerRadius = 8
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(iconContainer)
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 18)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(iconLabel)
        
        NSLayoutConstraint.activate([
            iconContainer.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            iconContainer.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 14),
            iconContainer.widthAnchor.constraint(equalToConstant: 42),
            iconContainer.heightAnchor.constraint(equalToConstant: 42),
            
            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12)
        ])
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .systemGray3
        chevron.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14),
            chevron.widthAnchor.constraint(equalToConstant: 8),
            chevron.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: row.topAnchor),
            button.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: row.trailingAnchor)
        ])
        
        return row
    }
    func updateProgress(total: Int, halal: Int) {
        let percent = total > 0 ? CGFloat(halal) / CGFloat(total) : 0
        let percentInt = Int(percent * 100)

        progressLabel.text = "\(percentInt)%"
        progressLabel.textColor = percentInt >= 50 ? UIColor.appGreen : UIColor.appRed
        progressBar.backgroundColor = percentInt >= 50 ? UIColor.appGreen : UIColor.appRed

        let fullWidth = progressCard.bounds.width - 32
        progressWidthConstraint?.constant = fullWidth * percent

        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
   
}
