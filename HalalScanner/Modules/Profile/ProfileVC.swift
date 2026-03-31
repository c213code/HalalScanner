//
//  ProfileVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 23.03.2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Combine


class ProfileVC: UIViewController {
    
    let profileView = ProfileView()
    

    weak var coordinator: AppCoordinator?
    
    let viewModel = ProfileViewModel()
    var cancellables = Set<AnyCancellable>()

        
    override func loadView() {
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Профиль"
        bindViewModel()
        viewModel.loadUserData()
        profileView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        profileView.editNameButton.addTarget(self, action: #selector(editNameTapped), for: .touchUpInside)
        profileView.editPasswordButton.addTarget(self, action:  #selector(editPasswordTapped), for: .touchUpInside)
    }
    
    func bindViewModel() {
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.profileView.nameLabel.text = name
            }
            .store(in: &cancellables)
        
        viewModel.$role
            .receive(on: DispatchQueue.main)
            .sink { [weak self] role in
                self?.profileView.roleBage.text = role
            }
            .store(in: &cancellables)
        
        viewModel.$totalScans
            .combineLatest(viewModel.$halalScans, viewModel.$haramScans)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] total, halal, haram in
                self?.profileView.setupStatus(total: total, halal: halal, haram: haram)
                self?.profileView.updateProgress(total: total, halal: halal)
            }
            .store(in: &cancellables)
 
    }
    
    @objc func logoutTapped() {
        coordinator?.logout()
    }
    
    @objc func editNameTapped() {
        let alert = UIAlertController(title: "Атымды өзгерту", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.placeholder = "Жаңа атыңызды енгізіңіз"
            textField.text = self?.viewModel.name
            textField.autocapitalizationType = .words
        }
        let saveAction = UIAlertAction(title: "Сақтау", style: .default) { [weak self] _ in
            guard let self = self, let newName = alert.textFields?.first?.text,!newName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            
            self.viewModel.updateName(newName) { success in
                if !success {
                    let errrorAlert = UIAlertController(title: "Қате", message:  "Атыңызды сақтау мүмкін болмады", preferredStyle: .alert)
                    errrorAlert.addAction(UIAlertAction(title: "Ок", style: .default))
                    self.present(errrorAlert, animated: true)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Бас тарту", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    @objc func editPasswordTapped() {
        let alert = UIAlertController(title: "Құпия сөзді өзгерту", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.placeholder = "Қазіргі пароль"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { field in
            field.placeholder = "Жаңа пароль (мин. 6 таңба)"
            field.isSecureTextEntry = true
            }
        alert.addTextField { field in
            field.placeholder = "Жаңа парольді растаңыз"
            field.isSecureTextEntry = true
        }
        let saveAction = UIAlertAction(title: "Өзгерту", style: .default) { [weak self] _ in
            guard let self = self,
                  let current = alert.textFields?[0].text, !current.isEmpty,
                  let newPass = alert.textFields?[1].text, !newPass.isEmpty,
                  let confirm = alert.textFields?[2].text else { return }
            
            guard newPass == confirm else {
                self.showError("Жаңа парольдер сәйкес келмейді")
                return
            }
            
            guard newPass.count >= 6 else {
                self.showError("Пароль тым қысқа (мин. 6 таңба)")
                return
            }
            
            self.viewModel.updatePassword(current: current, new: confirm) { result in
                switch result {
                case .success:
                    let ok = UIAlertController(title: "✅", message: "Пароль сәтті өзгертілді", preferredStyle: .alert)
                    ok.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(ok, animated: true)
                case .failure(let message):
                    self.showError(message)
                }
            }
        }
        
        alert.addAction(UIAlertAction(title: "Бас тарту", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
        
    }
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Қате", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
}
