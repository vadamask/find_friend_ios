//
//  SearchFriendsView.swift
//  FindFriends
//
//  Created by Вадим Шишков on 29.02.2024.
//
import Combine
import UIKit

protocol SearchFriendsViewDelegate: AnyObject {
    func showAlert(_ message: String)
}

final class SearchFriendsView: UIView {
    weak var delegate: SearchFriendsViewDelegate?
    private let viewModel: SearchFriendsViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundMain
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -13)
        return tableView
    }()
    
    init(viewModel: SearchFriendsViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadUsers() {
        viewModel.loadUsers()
    }
    
    private func bind() {
        viewModel.$state
            .sink { [unowned self] state in
                DispatchQueue.main.async {
                    switch state {
                    case .finishLoading:
                        UIBlockingProgressHUD.dismiss()
                        self.tableView.reloadData()
                    case .empty:
                        print("пусто")
                    case .loading:
                        UIBlockingProgressHUD.show()
                    case .error(let error):
                        self.delegate?.showAlert(error.message)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupViews() {
        backgroundColor = .backgroundMain
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchFriendCell.self, forCellReuseIdentifier: SearchFriendCell.reuseIdentifier)
    }
    
    private func setupLayout() {
        addSubviewWithoutAutoresizingMask(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension SearchFriendsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchFriendCell.reuseIdentifier,
            for: indexPath) as? SearchFriendCell 
        else { return UITableViewCell() }
        cell.configure(with: viewModel.userForRowAt(indexPath))
        return cell
    }
}

extension SearchFriendsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows,
           visibleIndexPaths.contains(indexPath) {
            viewModel.cellWillDisplay(at: indexPath)
        }
    }
}
