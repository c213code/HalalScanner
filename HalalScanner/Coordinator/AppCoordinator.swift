//
//  AppCoordinator.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 26.03.2026.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class AppCoordinator {
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        if Auth.auth().currentUser != nil {
            showMain()
        } else {
            showAuth()
        }
    }

    func showAuth() {
        let authVC = AuthVC()
        authVC.coordinator = self
        let nav = UINavigationController(rootViewController: authVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    
    func fetchRoleAndShowMain() {
        guard let uid = Auth.auth().currentUser?.uid else { showMain(); return }
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, _ in
            if let role = snapshot?.data()?["role"] as? String {
                UserDefaults.standard.set(role, forKey: "userRole")
            }
            DispatchQueue.main.async { self?.showMain() }
        }
    }

    func showMain() {
        let tabBar = TabBarVC()
        tabBar.coordinator = self
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }

    func logout() {
        try? Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "userRole")
        if let tabBar = window.rootViewController as? TabBarVC,
           let nav = tabBar.viewControllers?[1] as? UINavigationController,
           let scannerVC = nav.viewControllers.first as? ViewController {
            scannerVC.captureSession.stopRunning()
        }
        let authVC = AuthVC()
        authVC.coordinator = self
        let nav = UINavigationController(rootViewController: authVC)
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            self.window.rootViewController = nav
        }
    }
    func showProductSheet(from vc: UIViewController, product: Product, confidence: Int) {
        let sheet = ProductSheetVC(product:  product, confidence: confidence)
        sheet.modalPresentationStyle = .pageSheet
        
        if let sheetPresentation = sheet.sheetPresentationController {
            sheetPresentation.detents = [.medium()]
            sheetPresentation.prefersGrabberVisible = false
            sheetPresentation.preferredCornerRadius = 32
        }
        
        vc.present(sheet, animated: true)
        
    }
}

