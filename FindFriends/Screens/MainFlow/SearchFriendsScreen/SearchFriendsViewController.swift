//
//  SearchFriendsViewController.swift
//  FindFriends
//
//  Created by Вадим Шишков on 29.02.2024.
//

import UIKit

final class SearchFriendsViewController: UIViewController {
    private let searchFriendsView: SearchFriendsView
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Поиск"
        textField.backgroundColor = .searchTextFieldBackground
        textField.layer.cornerRadius = 10
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let leftImageView = UIImageView(image: UIImage(resource: .loupe))
        leftView.addSubview(leftImageView)
        leftImageView.center = leftView.center
        leftView.tintColor = .searchTextFieldTint
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let rightImageView = UIImageView(image: UIImage(resource: .filter))
        rightView.addSubview(rightImageView)
        rightImageView.center = rightView.center
        rightView.tintColor = .searchTextFieldTint
        textField.rightView = rightView
        textField.rightViewMode = .always
        
        let placeholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor.searchTextFieldTint
            ]
        )
        textField.attributedPlaceholder = placeholder
        return textField
    }()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchFriendsView.loadUsers()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Рекомендации"
        navigationItem.titleView = searchTextField
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundMain
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.primeDark,
            .font: UIFont.Medium.medium
        ]
        navigationItem.standardAppearance = appearance
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchTextField.frame = CGRect(x: 0, y: 0, width: searchFriendsView.bounds.width - 32, height: 36)
    }
}

extension SearchFriendsViewController: SearchFriendsViewDelegate {
    func showAlert(_ message: String) {
        
    }
    
    
}
