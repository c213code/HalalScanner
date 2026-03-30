//
//  FavoritesVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 28.03.2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Combine

class FavoritesVC: UIViewController {
    
    var favorites: [[String: Any]] = []
    
    var viewModel = FavoritesViewModel()
    
    var cancellables = Set<AnyCancellable>()
    let favoritesView = FavoritesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Сақталған"
        navigationItem.titleView = nil
        navigationController?.navigationBar.prefersLargeTitles = true
        
        favoritesView.collectionView.delegate = self
        favoritesView.collectionView.dataSource = self
        bindViewModel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    override func loadView() {
        view = favoritesView
    }
    
    
    func bindViewModel() {
        viewModel.$favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.favorites = items
                self?.favoritesView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func fetchFavorites() {
        viewModel.fetchScans()
    }
    
    func deleteFromFavorites(at indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let item = favorites[indexPath.item]
        guard let docId = item["documentId"] as? String else { return }
        
        Firestore.firestore().collection("favorites").document(uid).collection("items").document(docId).delete()
        
        favorites.remove(at: indexPath.item)
        favoritesView.collectionView.reloadData()
    }
    
}

extension FavoritesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.configure(with: favorites[indexPath.item])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let delete = UIAction(title: "Жою", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteFromFavorites(at: indexPath)
            }
            return UIMenu(title: "", children: [delete])
        }
        
    }
}
