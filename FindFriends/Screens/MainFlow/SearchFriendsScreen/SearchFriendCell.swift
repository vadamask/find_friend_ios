//
//  SearchFriendCell.swift
//  FindFriends
//
//  Created by Вадим Шишков on 29.02.2024.
//

import UIKit

final class SearchFriendCell: UITableViewCell {
    static let reuseIdentifier = "SearchFriendCell"
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 37
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var fullName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .primeDark
        label.font = .regular16
        return label
    }()
    
    private lazy var purpose: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .primeDark
        label.font = .regular12
        return label
    }()
    
    private lazy var age: UILabel = {
        let label = UILabel()
        label.textColor = .placeholder
        label.font = .regular12
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: SearchFriendCellViewModel) {
        fullName.text = model.fullName
        purpose.text = model.purpose
        if let age = model.age {
            
            self.age.text = "\(age) \(correctStringForNumber(age))"
        }
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupLayout() {
        contentView.addSubviewWithoutAutoresizingMask(backView)
        backView.addSubviewWithoutAutoresizingMask(avatar)
        backView.addSubviewWithoutAutoresizingMask(fullName)
        backView.addSubviewWithoutAutoresizingMask(purpose)
        backView.addSubviewWithoutAutoresizingMask(age)
        
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            avatar.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            avatar.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            avatar.widthAnchor.constraint(equalToConstant: 74),
            avatar.heightAnchor.constraint(equalToConstant: 74),
            avatar.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            
            fullName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            fullName.topAnchor.constraint(equalTo: avatar.topAnchor),
            
            purpose.leadingAnchor.constraint(equalTo: fullName.leadingAnchor),
            purpose.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 4),
            purpose.bottomAnchor.constraint(equalTo: avatar.bottomAnchor),
            purpose.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            age.leadingAnchor.constraint(equalTo: fullName.trailingAnchor, constant: 4),
            age.topAnchor.constraint(equalTo: fullName.topAnchor),
            age.trailingAnchor.constraint(equalTo: purpose.trailingAnchor)
        ])
    }
    
    private func correctStringForNumber(_ num: Int) -> String {
        switch num % 10 {
        case 1 where num % 100 != 11:
            return "год"
        case 2 where num % 100 != 12:
            return "года"
        case 3 where num % 100 != 13:
            return "года"
        case 4 where num % 100 != 14:
            return "года"
        default:
            return "лет"
        }
    }
}
