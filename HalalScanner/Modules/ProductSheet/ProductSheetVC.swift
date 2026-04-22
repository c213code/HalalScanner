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
    let viewModel: ProductSheetViewModel
    let productSheetView = ProductSheetView()
    
    
    var onRetry: (() -> Void)?

    
    override func loadView() {
        view = productSheetView
    }
    
    
    init(product: Product, confidence: Int) {
            self.viewModel = ProductSheetViewModel(product: product, confidence: confidence)
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         view.alpha = 0
         productSheetView.configure(with: viewModel)
         setupActions()
     }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
        }
    }
    func setupActions() {
        productSheetView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        productSheetView.retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }
    
    @objc func saveTapped() {
        productSheetView.saveButton.isEnabled = false
        productSheetView.saveButton.setTitle("Сақталуда...", for: .normal)

        viewModel.saveToFavorites { [weak self] success in
            DispatchQueue.main.async {
                guard let self else { return }
                if success {
                    self.dismiss(animated: true)
                } else {
                    self.productSheetView.saveButton.isEnabled = true
                    self.productSheetView.saveButton.setTitle("Қайта көру", for: .normal)
                    self.productSheetView.saveButton.backgroundColor = .appHaramText
                }
            }
        }
    }
        
        
        
    
    @objc func retryTapped() {
            dismiss(animated: true) { [weak self] in
                self?.onRetry?()
            }
        }
}

