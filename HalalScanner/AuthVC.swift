//
//  AuthVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 21.03.2026.
//

import UIKit
class AuthVC: UIViewController {
    
    let emailField = UITextField()
    let passwordFiled = UITextField()
    let loginButton = UIButton()
    let registerButton = UIButton()
    let iconLabel = UILabel()
    let iconBackgroundView = UIView()
    let appNameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white


        
        let stack = UIStackView()
        iconLabel.text = "🔑"
        iconLabel.font = .systemFont(ofSize: 54, weight: .bold)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        iconBackgroundView.backgroundColor =  UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1)
        iconBackgroundView.layer.cornerRadius = 28
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        iconBackgroundView.addSubview(iconLabel)
        
        view.addSubview(iconBackgroundView)

        
        
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            iconBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 92),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        appNameLabel.text = "HalalScanner"
        appNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textAlignment = .center
        
        
        emailField.placeholder = "Email"
        emailField.backgroundColor = .systemGray6
        emailField.layer.cornerRadius = 10
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        emailField.leftViewMode = .always
        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: 50)
            ])

        
        passwordFiled.placeholder = "Password"
        passwordFiled.backgroundColor = .systemGray6
        passwordFiled.layer.cornerRadius = 10
        passwordFiled.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        passwordFiled.leftViewMode = .always
        passwordFiled.isSecureTextEntry = true
        NSLayoutConstraint.activate([
            passwordFiled.heightAnchor.constraint(equalToConstant: 50)

            ])
        
        loginButton.setTitle("Tiркелу", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        loginButton.backgroundColor =  UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1)
        loginButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 50)

            ])
        
        
        registerButton.setTitle("Кіру", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        registerButton.backgroundColor = .white
        registerButton.layer.borderWidth = 1.5
        registerButton.layer.borderColor =  UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1).cgColor
        registerButton.layer.cornerRadius = 10
        registerButton.setTitleColor(UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1), for: .normal)
        NSLayoutConstraint.activate([
            registerButton.heightAnchor.constraint(equalToConstant: 50)
            

            ])

        
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Кіру/Тіркелу"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center
        
        stack.addArrangedSubview(appNameLabel)
        
        stack.addArrangedSubview(subtitleLabel)
        stack.setCustomSpacing(24, after: subtitleLabel)

        stack.addArrangedSubview(emailField)
        stack.addArrangedSubview(passwordFiled)
        stack.addArrangedSubview(loginButton)
        
        stack.addArrangedSubview(makeDivider())

        stack.addArrangedSubview(registerButton)
        
        
                                 
        
        stack.alignment = .fill

        

        
        view.addSubview(stack)
        
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])


        
        
        
    }
    func makeDivider() -> UIView {
        let container = UIView()
        
        let leftLine = UIView()
        let rightLine = UIView()
        let label = UILabel()
        
        leftLine.backgroundColor = .systemGray4
        rightLine.backgroundColor = .systemGray4
        label.text = "немесе"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(leftLine)
        container.addSubview(label)
        container.addSubview(rightLine)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            leftLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            rightLine.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    
}

