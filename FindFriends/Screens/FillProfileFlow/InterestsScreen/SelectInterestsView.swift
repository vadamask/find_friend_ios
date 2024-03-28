//
//  SelectInterestsBaseView.swift
//  FindFriends
//
//  Created by Vitaly on 04.03.2024.
//

import Combine
import UIKit

struct CollectionLayout {
    static let trailingOffsetCell: Double = 16
    static let leadingOffsetCell: Double = 16
    static let topOffsetCell: Double = 20
    static let heightOfCell: Double = 46
    static let spaceBetweenColumns: Double = 7
    static let spaceBetweenRows: Double = 15
    static let countOfColumsCell: Double = 2
}

final class  SelectInterestsView: BaseFillProfileView {
    
    let interestsViewModel = SelectInterestsViewModel()
    weak var delegate: CustomUIPageControlProtocol?
    
    private lazy var tagsSearchBar: UISearchBar = {
        var bar  = UISearchBar()
        bar.placeholder = "Поиск интересов"
        bar.searchBarStyle = UISearchBar.Style.minimal
        bar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск интересов", attributes: [
            .foregroundColor: UIColor.searchBar,
            .font: UIFont.Regular.medium
        ])
        bar.backgroundColor = .clear
        bar.searchTextField.textColor = UIColor.searchBar
        return bar
    }()
    
    private (set) lazy var tagsCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init() {
        super.init(header: "Интересы", screenPosition: 3, subheader: "Выберете свои увлечения, чтобы найти единомышленников")
        setupViews()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(header: String, screenPosition: Int, subheader: String = "") {
        fatalError("init(header:screenPosition:subheader:) has not been implemented")
    }
    
    func loadData() {
        interestsViewModel.getInterests()
    }
    
    @objc private func nextButtonTapped() {
        delegate?.sendPage(number: 3)
    }
    
    private func bind() {
        interestsViewModel.$interestsDidLoad
            .sink { [unowned self] _ in
                tagsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        interestsViewModel.$interestsIsSelected
            .sink { [unowned self] isSelected in
                nextButton.setEnabled(isSelected)
            }
            .store(in: &cancellables)
    }

    private func setupViews() {
        
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagsCollectionView.collectionViewLayout = columnLayout
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(TagsCollectionViewCell.self)
 
        nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupConstraints() {
        self.addSubviewWithoutAutoresizingMask(tagsSearchBar)
        self.addSubviewWithoutAutoresizingMask(tagsCollectionView)
        
        NSLayoutConstraint.activate([
            tagsCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tagsCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tagsCollectionView.topAnchor.constraint(equalTo: self.tagsSearchBar.bottomAnchor),
            tagsCollectionView.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor),
            
            tagsSearchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tagsSearchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tagsSearchBar.topAnchor.constraint(equalTo: self.screenSubheader.bottomAnchor, constant: 24),
            tagsSearchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - Collection data source

extension SelectInterestsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestsViewModel.showInterests.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: TagsCollectionViewCell = tagsCollectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCell(with: interestsViewModel.showInterests[indexPath.row])
        return cell
    }
}

// MARK: - FLow layout

extension SelectInterestsView: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int)
    -> CGFloat {
            return CollectionLayout.spaceBetweenColumns
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: CollectionLayout.topOffsetCell,
            left: CollectionLayout.leadingOffsetCell,
            bottom: 10,
            right: CollectionLayout.trailingOffsetCell
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CollectionLayout.spaceBetweenRows
    }
}

// MARK: - Collection delegate

extension SelectInterestsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interestsViewModel.cellDidTappedAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        interestsViewModel.cellDidTappedAt(indexPath)
    }
}
