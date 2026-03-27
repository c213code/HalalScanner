//
//  ProductSheetVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 19.03.2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProductSheetVC: UIViewController {
    let product: Product
    let handle = UIView()
    let emojiLabel = UILabel()
    let emojiContainer = UIView()
    let nameLabel = UILabel()
    let categoryLabel = UILabel()
    let halalLabel = UILabel()
    let halalBackground = UIView()
    
    let confidence: Int
    
    let saveButton = UIButton()
    let retryButton = UIButton()
    
    
    
    
    
    
    init(product: Product, confidence: Int) {
        self.product = product
        self.confidence = confidence
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
    }
    func setupUI() {
        let infoStack = UIStackView()
        let horizontalInfoStack = UIStackView()
        
        view.backgroundColor = .white
        
        handle.backgroundColor = UIColor.appBackground
        handle.layer.cornerRadius = 2
        
        handle.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(handle)
        
        
        NSLayoutConstraint.activate([
            handle.widthAnchor.constraint(equalToConstant: 36),
            handle.heightAnchor.constraint(equalToConstant: 4),
            handle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
        
        emojiLabel.text = product.emoji
        emojiContainer.backgroundColor = UIColor.appCardGreen
        emojiContainer.layer.cornerRadius = 36
        emojiContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emojiContainer)
        
        NSLayoutConstraint.activate([
            //            emojiContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            //            emojiContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 23),
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
        
        nameLabel.text = product.name
        nameLabel.textColor  = .black
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        
        categoryLabel.text = "Snacks"
        categoryLabel.font = .systemFont(ofSize: 23, weight: .regular)
        categoryLabel.textColor = .systemGray
        
        
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(categoryLabel)
        infoStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        
        
        view.addSubview(infoStack)
        
        //        NSLayoutConstraint.activate([
        //            infoStack.leadingAnchor.constraint(equalTo: emojiContainer.trailingAnchor, constant: 30),
        //            infoStack.centerYAnchor.constraint(equalTo: emojiContainer.centerYAnchor)
        //        ])
        switch product.halalStatus {
        case .halal: halalLabel.text = "Halal"
        case .haram: halalLabel.text = "Not Halal"
        case .doubtful: halalLabel.text = "Күмәнді"
        }
        halalLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        switch product.halalStatus {
        case .halal: halalLabel.textColor = .systemGreen
        case .haram: halalLabel.textColor = .systemRed
        case .doubtful: halalLabel.textColor = .systemOrange
        }
        halalLabel.setContentHuggingPriority(.required, for: .horizontal)
        halalLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        
        
        switch product.halalStatus {
        case .halal: halalBackground.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        case .haram: halalBackground.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        case .doubtful: halalBackground.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        }
        halalBackground.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        halalBackground.layer.cornerRadius = 12
        halalBackground.translatesAutoresizingMaskIntoConstraints = false
        halalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(halalBackground)
        halalBackground.addSubview(halalLabel)
        
        
        NSLayoutConstraint.activate([
            halalLabel.topAnchor.constraint(equalTo: halalBackground.topAnchor, constant: 10),
            halalLabel.bottomAnchor.constraint(equalTo: halalBackground.bottomAnchor, constant: -10),
            halalLabel.leadingAnchor.constraint(equalTo: halalBackground.leadingAnchor, constant: 15),
            halalLabel.trailingAnchor.constraint(equalTo: halalBackground.trailingAnchor, constant: -15)
        ])
        
        let row1 = UIStackView()
        row1.axis = .horizontal
        row1.spacing = 8
        row1.distribution = .fillEqually
        
        
        let row2 = UIStackView()
        row2.axis = .horizontal
        row2.spacing = 8
        row2.distribution = .fillEqually
        
        row1.addArrangedSubview(makeInfoCell(title: "Нақтылығы", value: "\(confidence)%"))
        row1.addArrangedSubview(makeInfoCell(title: "Статус", value: product.isHalal ? "Халал" : "Халал емес", valueColor: product.isHalal ?  UIColor.appGreen : .systemRed))
        
        row2.addArrangedSubview(makeInfoCell(title: "Калориясы", value: "\(product.calories)"))
        row2.addArrangedSubview(makeInfoCell(title: "Катерогия", value: "\(product.category)"))
        
        
        
        
        
        
        
        horizontalInfoStack.axis = .horizontal
        horizontalInfoStack.spacing = 20
        horizontalInfoStack.alignment = .center
        horizontalInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalInfoStack.addArrangedSubview(emojiContainer)
        horizontalInfoStack.addArrangedSubview(infoStack)
        horizontalInfoStack.addArrangedSubview(halalBackground)
        
        view.addSubview(horizontalInfoStack)
        
        NSLayoutConstraint.activate([
            horizontalInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            horizontalInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            horizontalInfoStack.topAnchor.constraint(equalTo: handle.topAnchor, constant: 16)
            
        ])
        
        
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 8
        grid.addArrangedSubview(row1)
        grid.addArrangedSubview(row2)
        grid.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(grid)
        
        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: horizontalInfoStack.bottomAnchor, constant: 16),
            grid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            grid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
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
        
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: grid.bottomAnchor, constant: 26),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 56)
            
        ])
        
        
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        
        
    }
    @objc func saveTapped() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "name": product.name,
            "emoji": product.emoji,
            "isHalal": product.isHalal,
            "confidence": confidence,
            "category": product.category,
            "calories": product.calories,
            "date": Date()
        ]
        
        db.collection("scans").document(userId).collection("items").addDocument(data: data) { error in
            if let error = error {
                print("Ошибка:", error.localizedDescription)
            }
            else{
                print("СОХРАНЕНО!")
                
            }
        }
        
        
    }
    func makeInfoCell(title: String, value: String, valueColor: UIColor = .black) -> UIView {
        
        let container = UIView()
        container.backgroundColor = UIColor.appBackground
        container.layer.cornerRadius = 12
        
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .systemGray
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        valueLabel.textColor = valueColor
        
        let verticalStackPercentStatus = UIStackView()
        verticalStackPercentStatus.axis = .vertical
        verticalStackPercentStatus.spacing = 4
        verticalStackPercentStatus.translatesAutoresizingMaskIntoConstraints = false
        
        
        verticalStackPercentStatus.addArrangedSubview(titleLabel)
        verticalStackPercentStatus.addArrangedSubview(valueLabel)
        
        container.addSubview(verticalStackPercentStatus)
        
        NSLayoutConstraint.activate([
            verticalStackPercentStatus.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            verticalStackPercentStatus.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            verticalStackPercentStatus.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            verticalStackPercentStatus.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
            
        ])
        
        return container
        
        
        
        
        
    }
    
    
    
    
}
