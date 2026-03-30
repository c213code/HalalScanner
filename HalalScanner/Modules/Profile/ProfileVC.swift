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
            }
            .store(in: &cancellables)
 
    }
    
    @objc func logoutTapped() {
        coordinator?.logout()
    }
    
    
    
}
