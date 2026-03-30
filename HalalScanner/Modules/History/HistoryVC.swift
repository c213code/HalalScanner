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
    let historyView = HistoryView()
//    var scans: [[String: Any]] = []
    
    var viewModel = HistoryViewModel()
    var cancellables = Set<AnyCancellable>()
        
    override func loadView() {
        view = historyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Тарих"
        bindViewModel()
        navigationItem.titleView = nil
        navigationController?.navigationBar.prefersLargeTitles = true
        historyView.tableView.delegate = self
        historyView.tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScans()
    }
    func bindViewModel() {
        viewModel.$scans
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.historyView.tableView.reloadData()
        }
            .store(in: &cancellables)
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
