//
//  AuthView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 28.03.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthView: UIView {
    
    let emailField = UITextField()
    let passwordFiled = UITextField()
    let loginButton = UIButton()
    let registerButton = UIButton()
    let iconLabel = UILabel()
    let iconBackgroundView = UIView()
    let appNameLabel = UILabel()
    let errorLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setupView() {
        backgroundColor = .appSurface
    
        iconLabel.text = "🔑"
        iconLabel.font = .systemFont(ofSize: 54, weight: .bold)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconBackgroundView.backgroundColor = UIColor.appGreen
        iconBackgroundView.layer.cornerRadius = 28
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconBackgroundView.addSubview(iconLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 92),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        let iconWrapper = UIView()
        iconWrapper.translatesAutoresizingMaskIntoConstraints = false
        iconWrapper.addSubview(iconBackgroundView)
        NSLayoutConstraint.activate([
            iconBackgroundView.centerXAnchor.constraint(equalTo: iconWrapper.centerXAnchor),
            iconBackgroundView.topAnchor.constraint(equalTo: iconWrapper.topAnchor),
            iconBackgroundView.bottomAnchor.constraint(equalTo: iconWrapper.bottomAnchor)
        ])
        
        appNameLabel.text = "HalalScanner"
        appNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        appNameLabel.textAlignment = .center
        appNameLabel.numberOfLines = 1
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Кіру/Тіркелу"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.placeholder = "Email"
        emailField.backgroundColor = .appBackground
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress
        emailField.layer.cornerRadius = 10
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        emailField.leftViewMode = .always
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordFiled.placeholder = "Password"
        passwordFiled.backgroundColor = .appBackground
        passwordFiled.layer.cornerRadius = 10
        passwordFiled.autocapitalizationType = .none
        passwordFiled.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        passwordFiled.leftViewMode = .always
        passwordFiled.isSecureTextEntry = true
        passwordFiled.translatesAutoresizingMaskIntoConstraints = false
        passwordFiled.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        errorLabel.textColor = UIColor.appRed
        errorLabel.font = .systemFont(ofSize: 13, weight: .medium)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = true
        
        loginButton.setTitle("Кіру", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        loginButton.backgroundColor = UIColor.appGreen
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.alpha = 0.5
        loginButton.isEnabled = false
        
        registerButton.setTitle("Тіркелу", for: .normal)
        registerButton.backgroundColor = .appSurface
        registerButton.layer.borderWidth = 1.5
        registerButton.layer.borderColor = UIColor.appGreen.cgColor
        registerButton.layer.cornerRadius = 10
        registerButton.setTitleColor(UIColor.appGreen, for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.alpha = 0.5
        registerButton.isEnabled = false
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(iconWrapper)
        stack.setCustomSpacing(16, after: iconWrapper)
        stack.addArrangedSubview(appNameLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.setCustomSpacing(24, after: subtitleLabel)
        stack.addArrangedSubview(emailField)
        stack.addArrangedSubview(passwordFiled)
        stack.addArrangedSubview(errorLabel)
        stack.addArrangedSubview(loginButton)
        stack.addArrangedSubview(makeDivider())
        stack.addArrangedSubview(registerButton)
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    func makeDivider() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let leftLine = UIView()
        let rightLine = UIView()
        let label = UILabel()
        
        leftLine.backgroundColor = .systemGray4
        rightLine.backgroundColor = .systemGray4
        
        label.text = "немесе"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(leftLine)
        container.addSubview(label)
        container.addSubview(rightLine)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 24),
            
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            leftLine.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            rightLine.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
}


        
        
        

