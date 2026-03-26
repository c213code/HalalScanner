//
//  ScanCell.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 22.03.2026.
//

import UIKit
import FirebaseFirestore

class ScanCell: UITableViewCell {
    
    let iconLabel = UILabel()
    let iconContainer = UIView()
    let nameLabel = UILabel()
    let categoryLabel = UILabel()
    let halalBadge = UILabel()
    let halalBackground = UIView()
    let nameStack = UIStackView()
    let dateLabel = UILabel()

    
    var isHalal: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = true
        
        iconContainer.backgroundColor = UIColor(red: 0.88, green: 0.95, blue: 0.87, alpha: 1)
        iconContainer.layer.cornerRadius = 14
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
    
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.font = .systemFont(ofSize: 28, weight: .medium)
        
        iconContainer.addSubview(iconLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        
        categoryLabel.font = .systemFont(ofSize: 17, weight: .regular)
        categoryLabel.textColor = .systemGray3
        
        
        nameStack.axis = .vertical
        nameStack.spacing = 0
        
        
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(categoryLabel)
        
        halalBadge.font = .systemFont(ofSize: 18, weight: .bold)
        halalBadge.textColor = isHalal ? .systemGreen : .systemRed
        
        halalBackground.backgroundColor = isHalal ? UIColor.green.withAlphaComponent(0.3) : UIColor.red.withAlphaComponent(0.3)
        
        halalBackground.translatesAutoresizingMaskIntoConstraints = false
        halalBadge.translatesAutoresizingMaskIntoConstraints = false
        halalBackground.setContentHuggingPriority(.required, for: .horizontal)
        halalBackground.layer.cornerRadius = 10

        
        contentView.addSubview(halalBackground)
        halalBackground.addSubview(halalBadge)
        
        NSLayoutConstraint.activate([
            halalBadge.topAnchor.constraint(equalTo: halalBackground.topAnchor, constant: 10),
            halalBadge.bottomAnchor.constraint(equalTo: halalBackground.bottomAnchor, constant: -10),
            halalBadge.leadingAnchor.constraint(equalTo: halalBackground.leadingAnchor, constant: 15),
            halalBadge.trailingAnchor.constraint(equalTo: halalBackground.trailingAnchor, constant: -15)
        ])
        
        dateLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dateLabel.textColor = .systemGray3
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.addArrangedSubview(halalBackground)
        rightStack.addArrangedSubview(dateLabel)
        contentView.addSubview(rightStack)
        
        contentView.addSubview(iconContainer)
        contentView.addSubview(nameStack)
        
        
        
        
        NSLayoutConstraint.activate([
            
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 70),
            iconContainer.heightAnchor.constraint(equalToConstant: 70),
            
            
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            rightStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            
            
            nameStack.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 10),
            nameStack.trailingAnchor.constraint(equalTo: halalBackground.leadingAnchor, constant: -10),
            nameStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)

        
        
       
        
        
        
    }
    func configure(with scan: [String: Any]) {
        let isHalal = scan["isHalal"] as? Bool ?? false
           nameLabel.text = scan["name"] as? String
           iconLabel.text = scan["emoji"] as? String
           categoryLabel.text = scan["category"] as? String
           halalBadge.text = isHalal ? "Халал" : "Халал емес"
           halalBadge.textColor = isHalal ? .systemGreen : .systemRed
           halalBackground.backgroundColor = isHalal ? UIColor.green.withAlphaComponent(0.3) : UIColor.red.withAlphaComponent(0.3)
           iconContainer.backgroundColor = isHalal ? UIColor(red: 0.88, green: 0.95, blue: 0.87, alpha: 1) : UIColor(red: 0.99, green: 0.92, blue: 0.92, alpha: 1)
        
        if let timestamp = scan["date"] as? Timestamp {
            let date = timestamp.dateValue()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, HH:mm"
            dateLabel.text = formatter.string(from: date)
        }
        
        halalBackground.setContentHuggingPriority(.required, for: .horizontal)
        halalBadge.setContentHuggingPriority(.required, for: .horizontal)
        
    }
}
