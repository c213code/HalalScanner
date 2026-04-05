//
//  AdminView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 04.04.2026.
//

import UIKit
import FirebaseFirestore


class AdminView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerCard = UIView()
    
    let userValueLabel = UILabel()
    let avrRatingLabel = UILabel()
    let totalFeedbackLabel = UILabel()
    
    let ratingStack = UIStackView()
    let feedbackStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        setupScrollView()
        setupHeader()
        setupStatCards()
        setupRatingSection()
        setupFeedbackSection()
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupHeader() {
        headerCard.backgroundColor = UIColor.appGreen
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerCard)
        
        NSLayoutConstraint.activate([
            headerCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerCard.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        let avatar = UIView()
        avatar.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 28
        headerCard.addSubview(avatar)
        
        let avatarLabel = UILabel()
        avatarLabel.text = "A"
        avatarLabel.font = .systemFont(ofSize: 22, weight: .bold)
        avatarLabel.textColor = .white
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatar.addSubview(avatarLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = "Админ панельі"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(titleLabel)
        
        let emailLabel = UILabel()
        emailLabel.text = "admin@halal.com"
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 14),
            
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 14),

        ])
    }
    
    func setupStatCards() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        let userCard = makeStatCard(
            value: "-",
            label: "Пайдаланушы",
            valueColor: .white,
            labelColor: UIColor.white.withAlphaComponent(0.7),
            bgColor:  UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1),
            valueLabel: userValueLabel
        )
        let ratingCard = makeStatCard(
            value: "-",
            label: "Орт. баға",
            valueColor: UIColor.appGreen,
            labelColor: UIColor.appGreen.withAlphaComponent(0.7),
            bgColor:  UIColor.appCardGreen,
            valueLabel: avrRatingLabel
        )
        let feedbackCard = makeStatCard(
            value: "-",
            label: "Пікір",
            valueColor: UIColor.systemBlue,
            labelColor: UIColor.systemBlue.withAlphaComponent(0.7),
            bgColor:  UIColor.systemBlue.withAlphaComponent(0.08),
            valueLabel: totalFeedbackLabel
        )
        
        stack.addSubview(userCard)
        stack.addSubview(ratingCard)
        stack.addSubview(feedbackCard)
        
    }
    
    func makeStatCard(value: String, label: String, valueColor: UIColor, labelColor: UIColor, bgColor: UIColor, valueLabel: UILabel) -> UIView{
        let card = UIView()
        card.backgroundColor = bgColor
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.text = value
        valueLabel.textColor =  valueColor
        valueLabel.textAlignment = .center
        valueLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelText = UILabel()
        labelText.text = label
        labelText.textColor = labelColor
        labelText.font = .systemFont(ofSize: 13, weight: .medium)
        labelText.textAlignment = .center
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(valueLabel)
        card.addSubview(labelText)
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            
            labelText.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            labelText.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 6)
        ])
        
        return card
    }
    
    func makeSectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupRatingSection() {
        let label = makeSectionLabel("БАҒАЛАУЛАР")
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.subviews[2].bottomAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        ratingStack.axis = .vertical
        ratingStack.spacing = 0
        ratingStack.layer.cornerRadius = 14
        ratingStack.clipsToBounds = true
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingStack)
        
        NSLayoutConstraint.activate([
            ratingStack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    func setupFeedbackSection() {
        let label = makeSectionLabel("ПІКІРЛЕР")
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        feedbackStack.axis = .vertical
        feedbackStack.spacing = 0
        feedbackStack.layer.cornerRadius = 14
        feedbackStack.clipsToBounds = true
        feedbackStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(feedbackStack)
        
        NSLayoutConstraint.activate([
            feedbackStack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            feedbackStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            feedbackStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            feedbackStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }
    
    func updateStats(users: Int, avgRating: Double, feedbacks: Int) {
        userValueLabel.text = "\(users)"
        avrRatingLabel.text = avgRating == 0 ? "-" :  String(format: "%.1f", avgRating)
        totalFeedbackLabel.text = "\(feedbacks)"
    }
    func updateRatings(_ ratings: [[String: Any]]){
        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard !ratings.isEmpty else {
            ratingStack.addArrangedSubview(makeEmptyRow("Бағалаулар жоқ"))
            return
        }
        ratings.enumerated().forEach { index, rating in
            let email = rating["email"] as? String ?? "-"
            let starts = rating["stars"] as? Int ?? 0
            let date = formatDate(value: rating["date"])
            let isLast = index == ratings.count - 1
            ratingStack.addArrangedSubview(makeRatingRow(email: email, date: date, stars: starts, isLast: isLast))

        }
    }
    func updateFeedbacks(_ feedbacks: [[String: Any]]) {
        feedbackStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard !feedbacks.isEmpty else {
            feedbackStack.addArrangedSubview(makeEmptyRow("Хабарламалар жоқ"))
            return
        }
        feedbacks.enumerated().forEach { index, feedback in
            let email = feedback["email"] as? String ?? "—"
            let message = feedback["message"] as? String ?? "—"
            let date = formatDate(value: feedback["date"])
            let isLast = index == feedbacks.count - 1
            feedbackStack.addArrangedSubview(makeFeedbackRow(email: email, date: date, message: message, isLast: isLast))
        }
    }
    func makeRatingRow(email: String, date: String, stars: Int, isLast: Bool) -> UIView {
        let row = UIView()
        row.backgroundColor = .white
        row.translatesAutoresizingMaskIntoConstraints = false
        
        let avatar = makeAvatar(email: email)
        row.addSubview(avatar)
        
        let emailLabel = UILabel()
        emailLabel.text = email
        emailLabel.textColor = .label
        emailLabel.font = .systemFont(ofSize: 14, weight: .bold)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(emailLabel)
     
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .systemGray3
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(dateLabel)
        
        let starsLabel = UILabel()
        starsLabel.attributedText = makeStars(count: stars)
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(starsLabel)
        
        if !isLast {
            let div = UIView()
            div.backgroundColor = .systemGray5
            div.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(div)
            
            NSLayoutConstraint.activate([
                div.bottomAnchor.constraint(equalTo: row.bottomAnchor),
                div.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 70),
                div.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                div.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
        
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 72),

            avatar.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            avatar.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 14),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),

            emailLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),

            dateLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),

            starsLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            starsLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14)
        ])
        
        return row
        
        
        
    }
    
    func makeFeedbackRow(email: String, date: String, message: String, isLast: Bool) -> UIView {
        let row = UIView()
        row.backgroundColor = .white
        row.translatesAutoresizingMaskIntoConstraints = false

        let avatar = makeAvatar(email: email)
        row.addSubview(avatar)

        let emailLabel = UILabel()
        emailLabel.text = email
        emailLabel.font = .systemFont(ofSize: 14, weight: .bold)
        emailLabel.textColor = .label
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(emailLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .systemGray3
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(dateLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 13)
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 2
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(messageLabel)

        if !isLast {
            let div = UIView()
            div.backgroundColor = .systemGray5
            div.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(div)
            NSLayoutConstraint.activate([
                div.bottomAnchor.constraint(equalTo: row.bottomAnchor),
                div.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 70),
                div.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                div.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }

        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: row.topAnchor, constant: 14),
            avatar.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 14),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),

            emailLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 14),
            emailLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),

            dateLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 14),
            dateLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14),

            messageLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            messageLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -14),
            messageLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -14)
        ])

        return row
    }
    
    func makeAvatar(email: String) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let colors: [UIColor] = [.systemGreen, .systemBlue, .systemOrange, .systemPurple, .systemPink, .systemTeal]
        let index = Int(email.unicodeScalars.first?.value ?? 0) % colors.count
        container.backgroundColor = colors[index].withAlphaComponent(0.2)
        
        let label = UILabel()
        label.text = String(email.prefix(1)).uppercased()
        label.textColor = colors[index]
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
               label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
               label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
           ])

        return container
        
    }
    func makeStars(count: Int) -> NSAttributedString {
        let filled = UIColor.orange
        let empty = UIColor.systemGray3
        let result = NSMutableAttributedString()
        for i in 1...5 {
            let star = NSAttributedString(
                string: "★",
                attributes: [.foregroundColor: i <= count ? filled : empty,
                             .font: UIFont.systemFont(ofSize: 18)]

            )
            result.append(star)
        }
        return result
    }
    private func makeEmptyRow(_ text: String) -> UIView {
        let row = UIView()
        row.backgroundColor = .white
        row.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: row.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])
        return row
    }
    
    func formatDate(value: Any?) -> String {
        if let timestamp = value as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM, HH:mm"
            formatter.locale = Locale(identifier: "kk_KZ")
            return formatter.string(from: timestamp.dateValue())
        }
        return "—"
    }
    

    
    
    
}
