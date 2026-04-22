//
//  HistoryView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit

class HistoryView : UIView {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let spinner   = UIActivityIndicatorView(style: .large)
    let emptyView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    func setupUI() {
        backgroundColor = .appBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(ScanCell.self, forCellReuseIdentifier: "ScanCell")
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        addSubview(tableView)

        // Loading spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .appGreen
        spinner.hidesWhenStopped = true
        addSubview(spinner)

        // Empty state
        let emptyIcon  = UILabel()
        emptyIcon.text = "🔍"
        emptyIcon.font = .systemFont(ofSize: 50)
        emptyIcon.translatesAutoresizingMaskIntoConstraints = false

        let emptyLabel = UILabel()
        emptyLabel.text = "Сканерлеулер жоқ"
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textColor = .systemGray
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        emptyView.addSubview(emptyIcon)
        emptyView.addSubview(emptyLabel)
        addSubview(emptyView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

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
        tableView.isHidden = true
    }

    func showContent(isEmpty: Bool) {
        spinner.stopAnimating()
        tableView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}
