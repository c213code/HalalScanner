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

    var isHalal: Bool = false
    let halalBadge = HalalBadgeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .appSurface
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 3
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(iconContainer)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(halalBadge)
        
        contentView.addSubview(stack)
    
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            contentView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 44)/2 )
        ])
        
    }
    func configure(with item: [String: Any]) {
        nameLabel.text = item["name"] as? String
        iconLabel.text = item["emoji"] as? String
        isHalal = item["isHalal"] as? Bool ?? false
        halalBadge.configure(isHalal: isHalal)
        iconContainer.backgroundColor = isHalal ? .appCardGreen : .appCardRed
    }
}
