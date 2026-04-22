//
//  ProfileView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit
import FirebaseAuth


class ProfileView : UIView {

    
    let scrollView  = UIScrollView()
    let contentView = UIView()

    
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

    
    private let totalValueLabel  = UILabel()
    private let halalValueLabel  = UILabel()
    private let haramValueLabel  = UILabel()

    let accountCard = UIView()
    let editNameButton = UIButton()
    let editPasswordButton = UIButton()

    let supportCard = UIView()
    let ratingButton = UIButton()
    let feedbackButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupHeader()
        setupLogoutButton()
    }
    required init?(coder: NSCoder) { fatalError() }

    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints  = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    
    func buildStatCards() {
        let totalCard = makeStatCard(valueLabel: totalValueLabel, label: "Барлығы",
                                     valueColor: .systemGray, labelColor: .systemGray3,
                                     bgColor: .appSurface)
        let halalCard = makeStatCard(valueLabel: halalValueLabel, label: "Халал",
                                     valueColor: .appHalalText, labelColor: .appHalalStatLabel,
                                     bgColor: .appHalalStatBg)
        let haramCard = makeStatCard(valueLabel: haramValueLabel, label: "Халал емес",
                                     valueColor: .appHaramText, labelColor: .appHaramStatLabel,
                                     bgColor: .appHaramStatBg)

        horizontalStackForCounters.axis = .horizontal
        horizontalStackForCounters.spacing = 8
        horizontalStackForCounters.distribution = .fillEqually
        horizontalStackForCounters.addArrangedSubview(totalCard)
        horizontalStackForCounters.addArrangedSubview(halalCard)
        horizontalStackForCounters.addArrangedSubview(haramCard)
        horizontalStackForCounters.translatesAutoresizingMaskIntoConstraints = false
    }

    
    func setupStatus(total: Int, halal: Int, haram: Int) {
        totalValueLabel.text = "\(total)"
        halalValueLabel.text = "\(halal)"
        haramValueLabel.text = "\(haram)"
    }

    private func makeStatCard(valueLabel: UILabel, label: String,
                               valueColor: UIColor, labelColor: UIColor, bgColor: UIColor) -> UIView {
        let card = UIView()
        card.layer.borderWidth = 1.5
        card.backgroundColor = bgColor
        card.layer.borderColor = valueColor.cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 14

        valueLabel.text = "0"
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
        contentView.addSubview(profileCard)

        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            profileCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileCard.heightAnchor.constraint(equalToConstant: 105)
        ])

        
        let avatar = UIView()
        avatar.backgroundColor = .appHeaderOverlay
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
        nameLabel.textColor = .white
        nameLabel.text = "Пайдаланушы"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(nameLabel)

        let emailLabel = UILabel()
        emailLabel.text = Auth.auth().currentUser?.email ?? "?"
        emailLabel.textColor = .appHeaderSubtext
        emailLabel.font = .systemFont(ofSize: 20)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        profileCard.addSubview(emailLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 12),
            emailLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ])

        roleBage.backgroundColor = .appHeaderBadge
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

        
        buildStatCards()
        contentView.addSubview(horizontalStackForCounters)
        NSLayoutConstraint.activate([
            horizontalStackForCounters.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 20),
            horizontalStackForCounters.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStackForCounters.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStackForCounters.heightAnchor.constraint(equalToConstant: 105)
        ])

        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("Шығу", for: .normal)
        logoutButton.setTitleColor(.appHaramText, for: .normal)
        logoutButton.backgroundColor = .appLogoutBackground
        logoutButton.layer.cornerRadius = 12
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        contentView.addSubview(logoutButton)

        setupProgressCard()
        enterCardAtt()
    }

    func setupLogoutButton() {
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: supportCard.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 68),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    
    func setupProgressCard() {
        progressCard.backgroundColor = .appSurface
        progressCard.layer.cornerRadius = 14
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressCard)

        NSLayoutConstraint.activate([
            progressCard.topAnchor.constraint(equalTo: horizontalStackForCounters.bottomAnchor, constant: 14),
            progressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            progressBar.bottomAnchor.constraint(equalTo: trackView.bottomAnchor)
        ])
        progressWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressWidthConstraint?.isActive = true
    }

    
    func createSupportCard(below anchorView: UIView, sectionText: String,
                            card: UIView, row1: UIView, row2: UIView) -> UIView {
        let sectionLabel = UILabel()
        sectionLabel.text = sectionText
        sectionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        sectionLabel.textColor = .systemGray
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sectionLabel)

        NSLayoutConstraint.activate([
            sectionLabel.topAnchor.constraint(equalTo: anchorView.bottomAnchor, constant: 20),
            sectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])

        card.backgroundColor = .appSurface
        card.layer.cornerRadius = 14
        card.clipsToBounds = true
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.heightAnchor.constraint(equalToConstant: 124)
        ])

        let devider = UIView()
        devider.backgroundColor = .systemGray5
        devider.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(row1)
        card.addSubview(devider)
        card.addSubview(row2)

        NSLayoutConstraint.activate([
            row1.topAnchor.constraint(equalTo: card.topAnchor),
            row1.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            row1.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            row1.heightAnchor.constraint(equalToConstant: 62),

            devider.topAnchor.constraint(equalTo: row1.bottomAnchor),
            devider.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            devider.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            devider.heightAnchor.constraint(equalToConstant: 0.5),

            row2.topAnchor.constraint(equalTo: devider.bottomAnchor),
            row2.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            row2.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            row2.heightAnchor.constraint(equalToConstant: 62),
            row2.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        return card
    }

    func enterCardAtt() {
        let nameRow     = makeAccountRow(title: "Атымды өзгерту",      icon: "✏️", iconBackgroundColor: .appGreenSubtle, button: editNameButton)
        let passwordRow = makeAccountRow(title: "Құпия сөзді өзгерту", icon: "🔒", iconBackgroundColor: .appBlueSubtle,  button: editPasswordButton)
        createSupportCard(below: progressCard, sectionText: "Аккаунт",
                          card: accountCard, row1: nameRow, row2: passwordRow)

        let ratingRow   = makeAccountRow(title: "Бағалау",             icon: "⭐️", iconBackgroundColor: .appBlueSubtle, button: ratingButton)
        let feedbackRow = makeAccountRow(title: "Байланыс/Сұрақ",      icon: "❓", iconBackgroundColor: .appRedSubtle,  button: feedbackButton)
        createSupportCard(below: accountCard, sectionText: "Қолдау",
                          card: supportCard, row1: ratingRow, row2: feedbackRow)
    }

    
    func makeAccountRow(title: String, icon: String,
                        iconBackgroundColor: UIColor, button: UIButton) -> UIView {
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
        guard total > 0 else { return }
        
        let percent    = CGFloat(halal) / CGFloat(total)
        let percentInt = Int(percent * 100)

        progressLabel.text = "\(percentInt)%"
        let color = percentInt >= 50 ? UIColor.appGreen : UIColor.appRed
        progressLabel.textColor     = color
        progressBar.backgroundColor = color

        layoutIfNeeded()   
        let fullWidth = progressCard.bounds.width - 32
        progressWidthConstraint?.constant = fullWidth * percent

        UIView.animate(withDuration: 0.8, delay: 0,
                       usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
