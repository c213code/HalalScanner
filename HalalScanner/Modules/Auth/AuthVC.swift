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
        viewModel.register { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.coordinator?.showMain() 
                }
            case .failure(let error):
                print("Ошибка при регистрации:", error.localizedDescription)
            }
        }
    }
    
    @objc func loginTapped() {
        viewModel.login { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.coordinator?.showMain()
                }
            case .failure(let error):
                print("Ошибка при логине:", error.localizedDescription)
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
    }
    
    
    
}

