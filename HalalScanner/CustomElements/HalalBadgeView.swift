//
//  HalalBadgeView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 02.04.2026.
//

import UIKit

class HalalBadgeView: UIView {
    let halalBadge = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    convenience init(isHalal: Bool) {
        self.init(frame: .zero)
        configure(isHalal: isHalal)
    }
    
    func setup() {
        layer.cornerRadius = 13
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        halalBadge.font = .systemFont(ofSize: 15, weight: .bold)
        halalBadge.textAlignment = .center
        halalBadge.numberOfLines = 0
        halalBadge.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(halalBadge)
        
        NSLayoutConstraint.activate([
            halalBadge.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            halalBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            halalBadge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            halalBadge.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8  )
        ])
        setContentHuggingPriority(.required, for: .horizontal)
        halalBadge.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func configure(isHalal: Bool) {
        halalBadge.text = isHalal ? "Халал" : "Халал емес"
        halalBadge.textColor = isHalal ? .appHalalText : .appHaramText
        backgroundColor = isHalal ? .appHalalBadge : .appHaramBadge
    }
}
