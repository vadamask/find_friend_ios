//
//  TagsCollectionView.swift
//  FindFriends
//
//  Created by Vitaly on 02.03.2024.
//

import Combine
import UIKit

final class TagsCollectionViewCell: UICollectionViewCell,  ReuseIdentifying  {
    
    private let tagLabel = UILabel()
    private var viewModel: InterestsCellViewModel? {
        didSet {
            bind()
        }
    }
    private var cancellables: Set<AnyCancellable> = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with model: InterestsCellViewModel) {
        tagLabel.text = model.name
        viewModel = model
    }
    
    private func setupViews() {
        contentView.backgroundColor = .backgroundLaunchScreen
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.borderGray.cgColor
        contentView.layoutMargins  = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        tagLabel.textAlignment = .center
        tagLabel.font = UIFont.Regular.medium16
    }
    
    private func setupConstraints() {
        contentView.addSubviewWithoutAutoresizingMask(tagLabel)
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            tagLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func bind() {
        viewModel?.$isSelected
            .sink { [weak self] isSelected in
                self?.contentView.backgroundColor = isSelected ? .selectedTag : .backgroundLaunchScreen
            }
            .store(in: &cancellables)
    }
}
