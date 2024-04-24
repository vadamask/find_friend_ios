import UIKit

protocol FillProfileDelegate: AnyObject {
    func showNextViewController()
    func genderIsSelect(_ gender: String)
    func birthdayIsSelect(_ birthday: String)
    func interestsIsSelect(_ interests: [InterestDto])
    func cityIsSelect(_ name: String?)
    func avatarIsSelect(_ avatar: Data?)
}

final class FillProfilePageViewController: UIPageViewController {

    private var pages: [UIViewController] = []
    private var profile: FillProfileDto?
    private var currentIndex = 0 {
        didSet {
            backButton.isHidden = !(1...4 ~= currentIndex)
            for i in 0...currentIndex {
                progressStackView.arrangedSubviews[i].backgroundColor = .Progress.current
            }
            if currentIndex < 4 {
                for i in (currentIndex + 1)...4 {
                    progressStackView.arrangedSubviews[i].backgroundColor = .Progress.remaining
                }
            }
        }
    }

    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .Progress.remaining
        stackView.layer.cornerRadius = 2
        stackView.axis = .horizontal
        stackView.spacing = 8.46
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        for _ in 1...5 {
            let view = UIView()
            view.backgroundColor = .Progress.remaining
            view.layer.cornerRadius = 2
            stackView.addArrangedSubview(view)
        }
        stackView.arrangedSubviews[0].backgroundColor = .Progress.current
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.setImage(.Symbols.leftChevron, for: .normal)
        return button
    }()

    override init(
        transitionStyle: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        configurePages()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        removeSwipeGesture()
        setupLayout()
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configurePages() {
        let genderViewModel = GenderViewModel(delegate: self)
        let genderView = GenderView(viewModel: genderViewModel)
        let genderVC = GenderViewController(genderView: genderView)
        
        let birthdayViewModel = BirthdayViewModel(delegate: self)
        let birthdayView = BirthdayView(viewModel: birthdayViewModel)
        let birthdayVC = BirthdayViewController(birthdayView: birthdayView)
        
        let interestsViewModel = SelectInterestsViewModel(delegate: self)
        let interestView = SelectInterestsView(viewModel: interestsViewModel)
        let interestsVC = SelectInterestsViewController(selectInterestsView: interestView)
        
        let selectCityViewModel = SelectCityViewModel(delegate: self)
        let selectCityView = SelectCityView(viewModel: selectCityViewModel)
        let selectCityVC = SelectCityViewController(selectCityView: selectCityView)
        
        let photoViewModel = PhotoViewModel(delegate: self)
        let photoView = PhotoView(viewModel: photoViewModel)
        let photoVC = PhotoViewController(photoView: photoView)
        
        [genderVC, birthdayVC, interestsVC, selectCityVC, photoVC].forEach { pages.append($0) }
    }
    
    private func setupLayout() {
        view.addSubviewWithoutAutoresizingMask(progressStackView)
        view.addSubviewWithoutAutoresizingMask(backButton)
        NSLayoutConstraint.activate([
            progressStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            progressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            progressStackView.heightAnchor.constraint(equalToConstant: 4),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }
    
    private func setDelegates() {
        dataSource = self
    }
    
    private func removeSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    private func showViewController(direction: NavigationDirection) {
        if case .forward = direction {
            currentIndex += 1
        } else {
            currentIndex -= 1
        }
        let viewController = pages[currentIndex]
        setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonTapped() {
        showViewController(direction: .reverse)
    }
}

// MARK: - UIPageViewControllerDataSource

extension FillProfilePageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
            currentIndex > 0
        else { return nil }
        return pages[currentIndex - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController)
    -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController),
              currentIndex < pages.count
        else { return nil }
        return pages[currentIndex + 1]
    }
}


// MARK: - FillProfilePageViewControllerDelegate

extension FillProfilePageViewController: FillProfileDelegate {
    func showNextViewController() {
        showViewController(direction: .forward)
    }
    
    func genderIsSelect(_ gender: String) {
        let profile = FillProfileDto(
            sex: gender,
            birthday: profile?.birthday ?? "",
            interests: profile?.interests ?? [],
            city: profile?.city,
            avatar: profile?.avatar
        )
        self.profile = profile
    }
    
    func birthdayIsSelect(_ birthday: String) {
        let profile = FillProfileDto(
            sex: profile?.sex ?? "",
            birthday: birthday,
            interests: profile?.interests ?? [],
            city: profile?.city,
            avatar: profile?.avatar
        )
        self.profile = profile
    }
    
    func interestsIsSelect(_ interests: [InterestDto]) {
        let profile = FillProfileDto(
            sex: profile?.sex ?? "",
            birthday: profile?.birthday ?? "",
            interests: interests,
            city: profile?.city,
            avatar: profile?.avatar
        )
        self.profile = profile
    }
    
    func cityIsSelect(_ name: String?) {
        let profile = FillProfileDto(
            sex: profile?.sex ?? "",
            birthday: profile?.birthday ?? "",
            interests: profile?.interests ?? [],
            city: name,
            avatar: profile?.avatar
        )
        self.profile = profile
    }
    
    func avatarIsSelect(_ avatar: Data?) {
        let profile = FillProfileDto(
            sex: profile?.sex ?? "",
            birthday: profile?.birthday ?? "",
            interests: profile?.interests ?? [],
            city: profile?.city,
            avatar: avatar
        )
        self.profile = profile
        finishFlow()
    }
    
    private func finishFlow() {
        let service = UsersService()
        service.loadMyInfo { [unowned self] result in
            switch result {
            case .success(_):
                service.updateMe(profile!) { [unowned self] result in
                    switch result {
                    case .success(_):
                        UserDefaults.standard.setValue(true, forKey: "fillingProfile")
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}
