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
    
    private let viewModel: SelectInterestsViewModel
    
    private lazy var tagsSearchBar: UISearchBar = {
        var bar  = UISearchBar()
        bar.placeholder = "Поиск интересов"
        bar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск интересов", attributes: [
            .foregroundColor: UIColor.Text.placeholder,
            .font: UIFont.regular17
        ])
        bar.backgroundColor = .white
        bar.searchTextField.backgroundColor = .white
        bar.searchTextField.textColor = .Text.primary
        return bar
    }()
    
    private (set) lazy var tagsCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: SelectInterestsViewModel) {
        self.viewModel = viewModel
        super.init(
            header: "Интересы",
            subheader: "Выберете свои увлечения, чтобы найти единомышленников",
            passButtonHidden: false
        )
        setupViews()
        setupConstraints()
        setupCollectionView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        viewModel.getInterests()
    }
    
    private func bind() {
        viewModel.interestsDidLoadPublisher
            .sink { [unowned self] _ in
                tagsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$interestsIsSelected
            .sink { [unowned self] isSelected in
                nextButton.setEnabled(isSelected)
            }
            .store(in: &cancellables)
    }

    private func setupViews() {
        backgroundColor = .white
        tagsSearchBar.delegate = self
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        passButton.addTarget(self, action: #selector(passButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagsCollectionView.collectionViewLayout = columnLayout
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(InterestsCell.self)
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
    
    @objc private func nextButtonTapped() {
        viewModel.nextButtonTapped()
    }
    
    @objc private func passButtonTapped() {
        viewModel.passButtonTapped()
    }
}

// MARK: - Collection data source

extension SelectInterestsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: InterestsCell = tagsCollectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCell(with: viewModel.modelFor(indexPath))
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
        viewModel.didSelectItemAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath)
    }
}


// MARK: - UISearchBarDelegate

extension SelectInterestsView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFieldDidChanged(searchText)
    }
}
