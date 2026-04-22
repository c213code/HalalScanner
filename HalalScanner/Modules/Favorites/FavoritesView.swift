//
//  FavoritesView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit

class FavoritesView: UIView {
    var collectionView: UICollectionView!
    let spinner   = UIActivityIndicatorView(style: .large)
    let emptyView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupSpinnerAndEmpty()
    }
    required init?(coder: NSCoder) { fatalError() }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let width = (UIScreen.main.bounds.width - 44) / 2
        layout.itemSize = CGSize(width: width, height: 180)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupSpinnerAndEmpty() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .appGreen
        spinner.hidesWhenStopped = true
        addSubview(spinner)

        let emptyIcon  = UILabel()
        emptyIcon.text = "⭐️"
        emptyIcon.font = .systemFont(ofSize: 50)
        emptyIcon.translatesAutoresizingMaskIntoConstraints = false

        let emptyLabel = UILabel()
        emptyLabel.text = "Сақталған өнімдер жоқ"
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textColor = .systemGray
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        emptyView.addSubview(emptyIcon)
        emptyView.addSubview(emptyLabel)
        addSubview(emptyView)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyIcon.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyIcon.topAnchor.constraint(equalTo: emptyView.topAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyIcon.bottomAnchor, constant: 12),
            emptyLabel.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor)
        ])
    }

    func showLoading() {
        spinner.startAnimating()
        emptyView.isHidden = true
        collectionView.isHidden = true
    }

    func showContent(isEmpty: Bool) {
        spinner.stopAnimating()
        collectionView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}

