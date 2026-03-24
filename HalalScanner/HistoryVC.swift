//
//  HistoryVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 22.03.2026.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HistoryVC: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    var scans: [[String: Any]] = []
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScans()
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

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

        
    }
    
    func fetchScans() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("scans").document(userId).collection("items").order(by: "date", descending: true).getDocuments { snapshot, error in
            if let error = error {
                print("Ошибка:", error.localizedDescription)
                return
            }
            self.scans = snapshot?.documents.map { $0.data() } ?? []
            print("SCANS COUNT:", self.scans.count)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scans.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScanCell", for: indexPath) as! ScanCell
        cell.configure(with: scans[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
