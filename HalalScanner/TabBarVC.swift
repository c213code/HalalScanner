//
//  TabBarVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 22.03.2026.
//

import UIKit

class TabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBar()
    }
    
    func setupBar() {
        let scannerVC = UINavigationController(rootViewController: ViewController())
        scannerVC.tabBarItem = UITabBarItem(title: "Сканер", image: UIImage(systemName: "camera.viewfinder"), tag: 0)

        let historyVC = UINavigationController(rootViewController: HistoryVC())
        historyVC.tabBarItem = UITabBarItem(title: "Тарих", image: UIImage(systemName: "clock"), tag: 1)
        
        
        viewControllers = [scannerVC, historyVC]

        tabBar.tintColor = UIColor(red: 0.11, green: 0.62, blue: 0.46, alpha: 1)

        tabBar.unselectedItemTintColor = .systemGray3
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .dark)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
