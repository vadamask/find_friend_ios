import UIKit
import Combine

final class MyProfileViewController: UIViewController {
    
    private let loginService = AuthService()
    
    private let viewModel: MyProfileViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        addView()
        applyConstraints()
        hideUI()
        profileImageView.image = loadImage()
        loadProfile()
        bind()
    }
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 440)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var profileName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.text = "Анастасия Станкевич"
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(.Symbols.pencil, for: .normal)
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var profileAge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "30 лет"
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plugPhoto")
        imageView.tintColor = .lightGray
        imageView.backgroundColor = .systemGray6
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var locationLabel: UILabel  = {
        let label = UILabel()
        label.text = "Москва"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private lazy var locationLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Symbols.location
        return imageView
    }()
    
    private lazy var locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel  = {
        let label = UILabel()
        label.text = "Хочу найти подругу чтобы ходить с ней на вечеринки :)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descroptionLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Symbols.smallPerson
        return imageView
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = false
        return view
    }()
    
    private lazy var descrioptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var friendsAndEventsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapFriendsLabel)))
        return view
    }()
    
    private lazy var friendsListLabel: UILabel = {
        let label = UILabel()
        label.text = "Друзей"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var meetingListLabel: UILabel = {
        let label = UILabel()
        label.text = "Событий"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var friendsListCountLabel: UILabel = {
        let label = UILabel()
        label.text = "7"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapFriendsLabel)))
        return label
    }()
    
    private lazy var meetingListCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 50
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 50
        stackView.isExclusiveTouch = true
        stackView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapFriendsLabel)))
        return stackView
    }()
    
    private lazy var createMeeting: PrimeOrangeButton = {
        let button = PrimeOrangeButton(text: "Создать событие", isEnabled: true)
        button.setImage(.Symbols.whitePlus, for: .normal)
        button.isHighlighted = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return button
    }()
    
    private lazy var jobView: CustomView = {
        let view = CustomView()
        view.firstLabel.text = "Работа"
        view.secondLabel.text = "Веб-дизайнер"
        view.isHidden = false
        return view
    }()
    
    private lazy var aboutMyselfView: CustomView = {
        let view = CustomView()
        view.firstLabel.text = "О себе"
        view.secondLabel.text = "Прочитала все книги Достоевского, много путешествую и люблю своего кота. Буду рада новым знакомствам."
        view.secondLabel.numberOfLines = 3
        view.isHidden = false
        return view
    }()
    
    private lazy var interestsView: CustomView = {
        let view = CustomView()
        view.firstLabel.text = "Интересы"
        view.secondLabel.isHidden = true
        view.isHidden = false
        return view
    }()
    
    private (set) lazy var tagsCollectionView = {
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: columnLayout)
        collectionView.collectionViewLayout = columnLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(InterestsCell.self)
        return collectionView
    }()
    
    private lazy var vkView: CustomView = {
        let view = CustomView()
        view.secondLabel.text = "id:123456789"
        view.secondLabel.addImage(.Social.vk, toStartWith: 25)
        view.firstLabel.isHidden = true
        view.isHidden = false
        return view
    }()
    
    private lazy var tgView: CustomView = {
        let view = CustomView()
        view.secondLabel.text = "@Nastya_0101"
        view.secondLabel.addImage(.Social.telegram, toStartWith: 25)
        view.firstLabel.isHidden = true
        view.isHidden = false
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var fullStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.distribution = .equalSpacing
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private func  hideUI() {
        locationView.isHidden = true
        descriptionView.isHidden = true
        descroptionLogo.isHidden = true
        jobView.isHidden = true
        aboutMyselfView.isHidden = true
        interestsView.isHidden = true
        vkView.isHidden = true
        tgView.isHidden = true
    }
    
    private func addView() {
        view.addSubview(scrollView)
        [profileImageView, fullStackView].forEach(scrollView.addSubviewWithoutAutoresizingMask(_:))
        [locationLabel, locationLogo].forEach(locationView.addSubviewWithoutAutoresizingMask(_:))
        [descriptionLabel, descroptionLogo].forEach(descriptionView.addSubviewWithoutAutoresizingMask(_:))
        [editButton].forEach(editButtonView.addSubviewWithoutAutoresizingMask(_:))
        [profileName, profileAge, editButtonView].forEach(profileImageView.addSubviewWithoutAutoresizingMask(_:))
        [friendsListCountLabel, meetingListCountLabel].forEach(countStackView.addArrangedSubview(_:))
        [friendsListLabel, meetingListLabel].forEach(labelStackView.addArrangedSubview(_:))
        [countStackView, labelStackView].forEach(friendsAndEventsView.addSubviewWithoutAutoresizingMask(_:))
        [tagsCollectionView].forEach(interestsView.addSubviewWithoutAutoresizingMask(_:))
        [locationView, descriptionView, friendsAndEventsView, createMeeting, jobView, aboutMyselfView, interestsView, vkView, tgView, logoutButton].forEach(fullStackView.addArrangedSubview(_:))
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: scrollView.frame.width),
            profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: 437),
            profileName.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 18),
            profileName.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -40),
            profileAge.leadingAnchor.constraint(equalTo: profileName.leadingAnchor),
            profileAge.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 5),
            editButtonView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -18),
            editButtonView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -30),
            editButtonView.heightAnchor.constraint(equalToConstant: 44),
            editButtonView.widthAnchor.constraint(equalToConstant: 44),
            editButton.centerXAnchor.constraint(equalTo: editButtonView.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: editButtonView.centerYAnchor),
            fullStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            fullStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            fullStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            locationView.heightAnchor.constraint(equalToConstant: 20),
            locationLogo.leadingAnchor.constraint(equalTo: locationView.leadingAnchor),
            locationLogo.centerYAnchor.constraint(equalTo: locationView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationLogo.trailingAnchor),
            descroptionLogo.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            descroptionLogo.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: descroptionLogo.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: locationView.trailingAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            descriptionView.heightAnchor.constraint(equalToConstant: 40),
            friendsAndEventsView.heightAnchor.constraint(equalToConstant: 95),
            countStackView.leadingAnchor.constraint(equalTo: friendsAndEventsView.leadingAnchor, constant: 100),
            countStackView.trailingAnchor.constraint(equalTo: friendsAndEventsView.trailingAnchor, constant: -100),
            countStackView.centerYAnchor.constraint(equalTo: friendsAndEventsView.centerYAnchor, constant: -10),
            labelStackView.topAnchor.constraint(equalTo: countStackView.bottomAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: friendsAndEventsView.leadingAnchor, constant: 80),
            labelStackView.trailingAnchor.constraint(equalTo: friendsAndEventsView.trailingAnchor, constant: -75),
            interestsView.heightAnchor.constraint(equalToConstant: 157),
            interestsView.firstLabel.heightAnchor.constraint(equalToConstant: 16),
            tagsCollectionView.leadingAnchor.constraint(equalTo: interestsView.leadingAnchor, constant: 10),
            tagsCollectionView.trailingAnchor.constraint(equalTo: interestsView.trailingAnchor, constant: -10),
            tagsCollectionView.topAnchor.constraint(equalTo: interestsView.firstLabel.bottomAnchor),
            tagsCollectionView.bottomAnchor.constraint(equalTo: interestsView.bottomAnchor, constant: -10),
            createMeeting.heightAnchor.constraint(equalToConstant: 48),
            logoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func loadProfile() {
        viewModel.loadProfile()
    }
    
    private func bind() {
        viewModel.$state
            .sink { state in
                DispatchQueue.main.async {
                    switch state {
                    case .finishLoading:
                        UIBlockingProgressHUD.dismiss()
                    case .loading:
                        UIBlockingProgressHUD.show()
                    case .error(let error):
                        print(error)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.$profile
            .sink { [unowned self] profile in
                DispatchQueue.main.async {
                    self.profileName.text = profile?.fullName
                    if let profileAge = profile?.age {
                        self.profileAge.text = "\(profileAge) \(self.correctStringForNumber(profileAge))"
                    }
                    self.locationLabel.text = profile?.city
                    self.descriptionLabel.text = profile?.purpose
                    if let friendsCount = profile?.friendsCount {
                        self.friendsListCountLabel.text = "\(friendsCount)"
                    }
                    self.jobView.secondLabel.text = profile?.profession
                    self.tgView.secondLabel.text = profile?.networkNick
                    self.tgView.secondLabel.text = profile?.networkNick
                }
            }
            .store(in: &cancellables)
    }

    private func loadImage() -> UIImage {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageUrl = documentsURL.appendingPathComponent("avatar.png")
        guard fileManager.fileExists(atPath: imageUrl.path) else {
            profileImageView.contentMode = .center
            profileName.textColor = .black
            profileAge.textColor = .black
            return UIImage(named: "plugPhoto")!
        }
        profileName.textColor = .white
        profileAge.textColor = .white
        return UIImage(contentsOfFile: imageUrl.path)!
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
    
    @objc private func didTapEditButton() {
        let vc = EditMyProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapFriendsLabel() {
        print("didTapFriendsLabel")
    }
    
    @objc private func didTapLogoutButton() {
        loginService.logoutUser { [unowned self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                AlertPresenter.show(in: self, model: AlertModel(message: error.message))
            }
        }
    }
}

extension MyProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        true
    }
}

extension MyProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InterestsCell = tagsCollectionView.dequeueReusableCell(indexPath: indexPath)


        cell.setupCell(with: InterestsCellViewModel(id: 0, name: "Спорт"))
        cell.isUserInteractionEnabled = false
        cell.contentView.layer.borderWidth = 0
        cell.isSelected = false
        cell.contentView.backgroundColor = .selectedTag
        return cell
    }
}

extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionLayout.spaceBetweenColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CollectionLayout.topOffsetCell, left: CollectionLayout.leadingOffsetCell, bottom: 10, right: CollectionLayout.trailingOffsetCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionLayout.spaceBetweenRows
    }
}

