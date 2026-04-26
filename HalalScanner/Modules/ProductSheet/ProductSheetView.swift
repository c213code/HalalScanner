//
//  ProductSheetView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit

class ProductSheetView : UIView {
    let handle = UIView()
       let emojiLabel = UILabel()
       let emojiContainer = UIView()
       let nameLabel = UILabel()
       let categoryLabel = UILabel()
       let halalBadge = HalalBadgeView()

       let saveButton = UIButton()
       let retryButton = UIButton()

       let confidenceValueLabel = UILabel()
       let statusValueLabel = UILabel()
       let caloriesValueLabel = UILabel()
       let categoryValueLabel = UILabel()
       let haramItemRow = UIView()
        

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func configure(with viewModel: ProductSheetViewModel) {
        emojiLabel.text = viewModel.emoji
        nameLabel.text  = viewModel.name
        categoryLabel.text = viewModel.category
        halalBadge.configure(isHalal: viewModel.isHalal)

        
        switch viewModel.halalStatus {
        case .halal:
            emojiContainer.backgroundColor = .appCardGreen
            statusValueLabel.textColor = .appGreen
        case .haram:
            emojiContainer.backgroundColor = .appCardRed
            statusValueLabel.textColor = .appHaramText
        case .doubtful:
            emojiContainer.backgroundColor = .appOrangeSubtle
            statusValueLabel.textColor = .systemOrange
        }

        confidenceValueLabel.text = viewModel.confidenceText
        statusValueLabel.text = viewModel.statusText
        caloriesValueLabel.text = viewModel.caloriesText
        categoryValueLabel.text = viewModel.category

        if let item = viewModel.haramItem {
            haramItemRow.isHidden = false
            if let label = haramItemRow.subviews.compactMap({ $0 as? UILabel }).last {
                label.text = item
            }
        } else {
            haramItemRow.isHidden = true
        }
    }
    
    
    func setupUI() {
        backgroundColor = .white

        let infoStack = UIStackView()
        let horizontalInfoStack = UIStackView()

        handle.backgroundColor = UIColor.appBackground
        handle.layer.cornerRadius = 2
        handle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(handle)

        NSLayoutConstraint.activate([
            handle.widthAnchor.constraint(equalToConstant: 36),
            handle.heightAnchor.constraint(equalToConstant: 4),
            handle.centerXAnchor.constraint(equalTo: centerXAnchor),
            handle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12)
        ])

        emojiContainer.layer.cornerRadius = 36
        emojiContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emojiContainer)

        NSLayoutConstraint.activate([
            emojiContainer.widthAnchor.constraint(equalToConstant: 90),
            emojiContainer.heightAnchor.constraint(equalToConstant: 90)
        ])

        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 45, weight: .bold)
        emojiContainer.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContainer.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContainer.centerYAnchor)
        ])

        infoStack.axis = .vertical
        infoStack.spacing = 2
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)

        categoryLabel.font = .systemFont(ofSize: 23, weight: .regular)
        categoryLabel.textColor = .systemGray

        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(categoryLabel)
        infoStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

        horizontalInfoStack.axis = .horizontal
        horizontalInfoStack.spacing = 20
        horizontalInfoStack.alignment = .center
        horizontalInfoStack.translatesAutoresizingMaskIntoConstraints = false

        horizontalInfoStack.addArrangedSubview(emojiContainer)
        horizontalInfoStack.addArrangedSubview(infoStack)
        horizontalInfoStack.addArrangedSubview(halalBadge)

        addSubview(horizontalInfoStack)

        NSLayoutConstraint.activate([
            horizontalInfoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalInfoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            horizontalInfoStack.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 16)
        ])

        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        row1.distribution = .fillEqually

        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8
        row2.distribution = .fillEqually

        row1.addArrangedSubview(makeInfoCell(title: "Нақтылығы", valueLabel: confidenceValueLabel))
        row1.addArrangedSubview(makeInfoCell(title: "Статус", valueLabel: statusValueLabel))

        row2.addArrangedSubview(makeInfoCell(title: "Калориясы", valueLabel: caloriesValueLabel))
        row2.addArrangedSubview(makeInfoCell(title: "Категория", valueLabel: categoryValueLabel))

        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 8
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.addArrangedSubview(row1)
        grid.addArrangedSubview(row2)

        addSubview(grid)

        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: horizontalInfoStack.bottomAnchor, constant: 16),
            grid.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            grid.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        
        haramItemRow.backgroundColor = UIColor.systemRed.withAlphaComponent(0.07)
        haramItemRow.layer.cornerRadius = 10
        haramItemRow.isHidden = true
        haramItemRow.translatesAutoresizingMaskIntoConstraints = false

        let warnIcon = UILabel()
        warnIcon.text = "⚠️"
        warnIcon.font = .systemFont(ofSize: 14)
        warnIcon.translatesAutoresizingMaskIntoConstraints = false

        let warnTitle = UILabel()
        warnTitle.text = "Күмәнді қоспалары:"
        warnTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        warnTitle.textColor = .appHaramText
        warnTitle.translatesAutoresizingMaskIntoConstraints = false

        let ingredientLabel = UILabel()
        ingredientLabel.font = .systemFont(ofSize: 13)
        ingredientLabel.textColor = .secondaryLabel
        ingredientLabel.numberOfLines = 0
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false

        haramItemRow.addSubview(warnIcon)
        haramItemRow.addSubview(warnTitle)
        haramItemRow.addSubview(ingredientLabel)
        addSubview(haramItemRow)

        NSLayoutConstraint.activate([
            haramItemRow.topAnchor.constraint(equalTo: grid.bottomAnchor, constant: 12),
            haramItemRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            haramItemRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            warnIcon.leadingAnchor.constraint(equalTo: haramItemRow.leadingAnchor, constant: 12),
            warnIcon.topAnchor.constraint(equalTo: haramItemRow.topAnchor, constant: 10),

            warnTitle.leadingAnchor.constraint(equalTo: warnIcon.trailingAnchor, constant: 6),
            warnTitle.centerYAnchor.constraint(equalTo: warnIcon.centerYAnchor),

            ingredientLabel.topAnchor.constraint(equalTo: warnIcon.bottomAnchor, constant: 4),
            ingredientLabel.leadingAnchor.constraint(equalTo: haramItemRow.leadingAnchor, constant: 12),
            ingredientLabel.trailingAnchor.constraint(equalTo: haramItemRow.trailingAnchor, constant: -12),
            ingredientLabel.bottomAnchor.constraint(equalTo: haramItemRow.bottomAnchor, constant: -10)
        ])

        saveButton.setTitle("Сақтау", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.backgroundColor = UIColor.appGreen
        saveButton.layer.cornerRadius = 8

        retryButton.backgroundColor = .clear
        retryButton.setTitleColor(UIColor.appRed, for: .normal)
        retryButton.layer.borderWidth = 1.5
        retryButton.layer.borderColor = UIColor.appRed.cgColor
        retryButton.setTitle("Қайтадан", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        retryButton.layer.cornerRadius = 8

        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(retryButton)
        buttonStack.addArrangedSubview(saveButton)

        addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: haramItemRow.bottomAnchor, constant: 14),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    func makeInfoCell(title: String, valueLabel: UILabel) -> UIView {
            let container = UIView()
            container.backgroundColor = UIColor.appBackground
            container.layer.cornerRadius = 12

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
            titleLabel.textColor = .systemGray

            valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
            valueLabel.textColor = .black

            let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(stack)

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
                stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
                stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
                stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
            ])

            return container
        }

}
