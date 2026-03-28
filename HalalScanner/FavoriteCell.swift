//
//  FavoriteCell.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 28.03.2026.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    let iconLabel = UILabel()
    let iconContainer = UIView()
    let nameLabel = UILabel()
    let halalBadge = UILabel()
    let halalBackground = UIView()
    
    var isHalal: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        iconContainer.backgroundColor = UIColor.appCardGreen
        iconContainer.layer.cornerRadius = 14
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.font = .systemFont(ofSize: 28, weight: .medium)
        
        iconContainer.addSubview(iconLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 60),
            iconContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        
        halalBadge.font = .systemFont(ofSize: 17, weight: .bold)
        halalBackground.layer.cornerRadius = 10
        halalBadge.translatesAutoresizingMaskIntoConstraints = false
        halalBackground.translatesAutoresizingMaskIntoConstraints = false
        
        halalBackground.addSubview(halalBadge)
        
        NSLayoutConstraint.activate([
            halalBadge.topAnchor.constraint(equalTo: halalBackground.topAnchor, constant: 10),
            halalBadge.bottomAnchor.constraint(equalTo: halalBackground.bottomAnchor, constant: -10),
            halalBadge.leadingAnchor.constraint(equalTo: halalBackground.leadingAnchor, constant: 10),
            halalBadge.trailingAnchor.constraint(equalTo: halalBackground.trailingAnchor, constant: -10)
        ])
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(iconContainer)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(halalBackground)
        
        contentView.addSubview(stack)
    
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    func configure(with item: [String: Any]) {
        nameLabel.text = item["name"] as? String
        iconLabel.text = item["emoji"] as? String
        isHalal = item["isHalal"] as? Bool ?? false
        halalBadge.text = isHalal ? "Халал" : "Халал емес"
        halalBadge.textColor = isHalal ? .systemGreen : .systemRed
        halalBackground.backgroundColor = isHalal ? UIColor.green.withAlphaComponent(0.2) : UIColor.red.withAlphaComponent(0.2)
        iconContainer.backgroundColor = isHalal ? .appCardGreen : .appCardRed
        
        
    }
}
