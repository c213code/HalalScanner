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
    
    
    
}
