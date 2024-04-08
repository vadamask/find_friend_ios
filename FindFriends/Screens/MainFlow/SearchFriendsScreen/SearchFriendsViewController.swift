//
//  SearchFriendsViewController.swift
//  FindFriends
//
//  Created by Вадим Шишков on 29.02.2024.
//

import UIKit

final class SearchFriendsViewController: UIViewController {
    private let searchFriendsView: SearchFriendsView
    
    init(searchFriendsView: SearchFriendsView) {
        self.searchFriendsView = searchFriendsView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = searchFriendsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        searchFriendsView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchFriendsView.loadUsers()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Рекомендации"
        navigationItem.titleView = searchFriendsView.searchTextField
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundMain
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.primeDark,
            .font: UIFont.medium24
        ]
        navigationItem.standardAppearance = appearance
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchFriendsView.searchTextField.frame = CGRect(x: 0, y: 0, width: searchFriendsView.bounds.width - 32, height: 36)
    }
}

extension SearchFriendsViewController: SearchFriendsViewDelegate {
    func showAlert(_ message: String) {
        AlertPresenter.show(in: self, model: AlertModel(message: message))
    }
}
