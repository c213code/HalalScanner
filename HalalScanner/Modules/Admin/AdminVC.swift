//
//  AdminVC.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 04.04.2026.
//

import UIKit
import Combine

class AdminVC: UIViewController {

    let adminView = AdminView()
    let viewModel = AdminViewModel()
    var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = adminView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Админ панелі"
        bindViewModel()
        viewModel.fetchData()
    }

    func bindViewModel() {
        viewModel.$totalUsers
            .combineLatest(viewModel.$avarageRating, viewModel.$totalFeedbacks)
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users, avg, feedbacks in
                self?.adminView.updateStats(users: users, avgRating: avg, feedbacks: feedbacks)
            }
            .store(in: &cancellables)

        viewModel.$recentRatings
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ratings in
                self?.adminView.updateRatings(ratings)
            }
            .store(in: &cancellables)

        viewModel.$recentFeedbacks
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feedbacks in
                self?.adminView.updateFeedbacks(feedbacks)
            }
            .store(in: &cancellables)
    }
}
