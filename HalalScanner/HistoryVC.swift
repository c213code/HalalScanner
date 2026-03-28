//
//  HistoryVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 22.03.2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Combine

class HistoryVC: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

//    var scans: [[String: Any]] = []
    
    var viewModel = HistoryViewModel()
    var cancellables = Set<AnyCancellable>()
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScans()
    }
    func bindViewModel() {
        viewModel.$scans
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
        }
            .store(in: &cancellables)
    }
    func setupUI() {
        title = "Тарих"
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Барлық сканерлеулер"
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .systemGray
        navigationItem.titleView = nil
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemGray6
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        tableView.register(ScanCell.self, forCellReuseIdentifier: "ScanCell")
        tableView.rowHeight = 100
        tableView.separatorStyle = .none

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)

        
    }
    
    func fetchScans() {
        viewModel.fetchScans()
    }
    func saveToFavorites(scan: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var data = scan
        data["savedAt"] = Date()
        Firestore.firestore().collection("favorites").document(uid).collection("items")
            .addDocument(data: data) { error in
                if error == nil {
                    print("ДОБАВЛЕНО В ИЗБРАННОЕ")
                }
            }
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.scans.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScanCell", for: indexPath) as! ScanCell
        cell.configure(with: viewModel.scans[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let saveAction = UIContextualAction(style: .normal, title: "Сақтау") {_, _, completion in
            let scan = self.viewModel.scans[indexPath.section]
            self.saveToFavorites(scan: scan)
            completion(true)

        }
        saveAction.backgroundColor = UIColor.systemOrange
        return UISwipeActionsConfiguration(actions: [saveAction])
    }
}
