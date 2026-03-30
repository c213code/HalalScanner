//
//  AuthVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 21.03.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthVC: UIViewController {
    
    weak var coordinator: AppCoordinator?
    
    var viewModel = AuthViewModel()
    let authView = AuthView()
    
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActions()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupActions() {
        authView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        authView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        authView.emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        authView.passwordFiled.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func emailChanged() {
        viewModel.email = authView.emailField.text ?? ""
    }
    @objc func passwordChanged() {
        viewModel.password = authView.passwordFiled.text ?? ""
    }
    
    @objc func registerTapped() {
        viewModel.errorMessage = ""
        viewModel.errorField = .none
        viewModel.register { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.coordinator?.showMain() 
                }
            case .failure(let error):
                break
            }
        }
    }
    
    @objc func loginTapped() {
        viewModel.errorMessage = ""
        viewModel.errorField = .none
        viewModel.login { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.coordinator?.showMain()
                }
            case .failure(let error):
                break
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func bindViewModel() {
        viewModel.isFormValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.authView.loginButton.alpha = isValid ? 1.0 : 0.5
                self?.authView.loginButton.isEnabled = isValid
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.isFormValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.authView.registerButton.alpha = isValid ? 1.0 : 0.5
                self?.authView.registerButton.isEnabled = isValid
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if message.isEmpty {
                    self.authView.errorLabel.isHidden = true
                    self.authView.errorLabel.text = nil
                } else {
                    self.authView.errorLabel.text = self.mapError(message)
                    self.authView.errorLabel.isHidden = false
                }
            }.store(in: &viewModel.cancellables)
        
        viewModel.$errorField
            .receive(on: DispatchQueue.main)
            .sink { [weak self] field in
                guard let self = self else { return }
                
                self.authView.emailField.layer.borderWidth = 0
                self.authView.passwordFiled.layer.borderWidth = 0
                
                switch field {
                case .email:
                    self.authView.emailField.layer.borderWidth = 1.5
                    self.authView.emailField.layer.borderColor = UIColor.appRed.cgColor
                case .password:
                    self.authView.passwordFiled.layer.borderWidth = 1.5
                    self.authView.passwordFiled.layer.borderColor = UIColor.appRed.cgColor
                case .none:
                    break
                }
            }.store(in: &viewModel.cancellables)
    }
    
    func mapError(_ message: String) -> String {
        if message.contains("password is invalid") || message.contains("wrong-password") {
            return "Қате пароль"
        } else if message.contains("no user record") || message.contains("user-not-found") {
            return "Бұл email тіркелмеген"
        } else if message.contains("email address is already in use") {
            return "Бұл email бұрыннан тіркелген"
        } else if message.contains("badly formatted") {
            return "Email форматы қате"
        } else if message.contains("network") {
            return "Интернет байланысын тексеріңіз"
        } else {
            return "Қате орын алды. Қайталап көріңіз"
        }
    }
    
    
    
}

