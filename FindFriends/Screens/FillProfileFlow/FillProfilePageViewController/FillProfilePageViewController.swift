//
//  CustomUIPageViewController.swift
//  FindFriends
//
//  Created by Ognerub on 3/3/24.
//

import UIKit

protocol FillProfileDelegate: AnyObject {
    func showControllerWithIndex(_ index: Int)
    func genderIsSelect(_ gender: String)
    func birthdayIsSelect(_ birthday: String)
    func interestsIsSelect(_ interests: [Int])
    func cityIsSelect(_ id: Int?)
    func avatarIsSelect(_ avatar: Data?)
    func finishFlow()
}

final class FillProfilePageViewController: UIPageViewController {

    private var pages: [UIViewController] = []
    private var profile: FillProfileDto?

    private lazy var pageControl: FillProfilePageControl = {
        let control = FillProfilePageControl(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .clear
        control.pageIndicatorTintColor = .clear
        return control
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.setImage(.back, for: .normal)
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
        
        let cityViewModel = CityViewModel(delegate: self)
        let cityVC = CityViewController(viewModel: cityViewModel)
        
        let photoVC = PhotoViewController()
        
        [genderVC, birthdayVC, interestsVC, cityVC, photoVC].forEach { pages.append($0) }
    }
    
    private func setupLayout() {
        view.addSubviewWithoutAutoresizingMask(pageControl)
        view.addSubviewWithoutAutoresizingMask(backButton)
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            pageControl.heightAnchor.constraint(equalToConstant: 36),
            backButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: pageControl.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setDelegates() {
        dataSource = self
        delegate = self

       
    }
    
    private func removeSwipeGesture() {
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    private func showViewControllerWith(index: Int, direction: NavigationDirection) {
        pageControl.currentPage = index
        let viewController = pages[index]
        setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    @objc
    private func backButtonTapped() {
        showViewControllerWith(index: pageControl.currentPage - 1, direction: .reverse)
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

// MARK: - UIPageViewControllerDelegate

extension FillProfilePageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

// MARK: - FillProfilePageViewControllerDelegate

extension FillProfilePageViewController: FillProfileDelegate {
    func showControllerWithIndex(_ index: Int) {
        showViewControllerWith(index: index, direction: .forward)
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
    
    func interestsIsSelect(_ interests: [Int]) {
        let profile = FillProfileDto(
            sex: profile?.sex ?? "",
            birthday: profile?.birthday ?? "",
            interests: interests,
            city: profile?.city,
            avatar: profile?.avatar
        )
        self.profile = profile
    }
    
    func cityIsSelect(_ id: Int?) {
        let profile = FillProfileDto(
            sex: profile?.sex ?? "",
            birthday: profile?.birthday ?? "",
            interests: profile?.interests ?? [],
            city: id,
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
    }
    
    func finishFlow() {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first
        else { fatalError("Invalid Configuration") }
        let tabBar = TabBar()
        let tabBarController = TabBarController(customTabBar: tabBar)
        window.rootViewController = tabBarController
    }
}
