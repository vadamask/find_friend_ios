import UIKit

final class CreateEventViewController: UIViewController {
    
    private var segmentedControl: UISegmentedControl!
    private var navBarSeparator: UIView!
    
    private let segmentView: SegmentView = {
        let segmentView = SegmentView()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    private let segment1View: Segment1View = {
        let segmentView = Segment1View()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    private let segment2View: Segment2View = {
        let segmentView = Segment2View()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    private let segment3View: Segment3View = {
        let segmentView = Segment3View()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Продолжить", for: .normal)
        button.backgroundColor = UIColor(named: "lightOrange")
        button.titleLabel?.font = .semibold17
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        setupNavigationBar()
        setupNavigationBarSeparator()
        setupSegmentedControl()
        setupUI()
        segmentView.setupEventUI()
        segment1View.setupTimeUI()
        segment2View.setupParticipantUI()
        segment3View.setupPriceUI()
        navigationItem.hidesBackButton = true
        segmentView.viewController = self
        
        segment1View.isHidden = true
        segment2View.isHidden = true
        segment3View.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let maxSegmentHeight = max(segmentView.frame.height, segment1View.frame.height, segment2View.frame.height)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: maxSegmentHeight + 20)
    }
    
    private func setupNavigationBar() {
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(named: "primeDark")
        
        let titleLabel = UILabel()
        titleLabel.text = "Новое мероприятие"
        titleLabel.font = .semibold17
        titleLabel.textColor = UIColor(named: "primeDark")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.titleView = titleLabel
    }
    
    private func setupNavigationBarSeparator() {
        navBarSeparator = UIView()
        navBarSeparator.backgroundColor = UIColor(named:"lightOrange")
        navBarSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navBarSeparator)
        
        NSLayoutConstraint.activate([
            navBarSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBarSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBarSeparator.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            navBarSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupSegmentedControl() {
        let items = ["Описание", "Время", "Участники", "Цена"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        segmentedControl.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        
        segmentedControl.setBackgroundImage(createImage(UIColor(named: "secondaryOrange")!), for: .selected, barMetrics: .default)
        segmentedControl.setBackgroundImage(createImage(UIColor(named: "textFieldGrey")!), for: .normal, barMetrics: .default)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "primeDark") ?? .black], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "placeholder") ?? .gray], for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for i in 0..<segmentedControl.numberOfSegments {
            if i == segmentedControl.selectedSegmentIndex {
                segmentedControl.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
                segmentedControl.subviews[i].layer.borderWidth = 1
                segmentedControl.subviews[i].layer.cornerRadius = 5
                segmentedControl.subviews[i].layer.masksToBounds = true
                segmentedControl.subviews[i].layer.borderColor = UIColor(named: "mainOrange")?.cgColor
                segmentedControl.subviews[i].frame.size.height = 44
            } else {
                segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12)], for: .normal)
                segmentedControl.subviews[i].layer.borderWidth = 0
                segmentedControl.subviews[i].layer.cornerRadius = 0
                segmentedControl.subviews[i].frame.size.height = 28
            }
        }
    }
    
    private func createImage(_ color: UIColor) -> UIImage? {
        let size = CGSize(width: 1, height: 32)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero) else { return nil }
        return image
    }
    
    private func setupUI() {
        view.addSubview(segmentedControl)
        view.addSubview(scrollView)
        scrollView.addSubview(segmentView)
        scrollView.addSubview(segment1View)
        scrollView.addSubview(segment2View)
        scrollView.addSubview(segment3View)
        view.addSubview(continueButton)
        setupConstraints()
        segmentView.addTapGestureToPlusContainerView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: navBarSeparator.topAnchor, constant: 32),
            segmentedControl.heightAnchor.constraint(equalToConstant: 28),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            continueButton.heightAnchor.constraint(equalToConstant: 48),
            
        ])
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continueButtonTapped() {
        // "Продолжить"
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewDidLayoutSubviews()
        segmentedControl.layoutIfNeeded()
        
        switch sender.selectedSegmentIndex {
        case 0:
            // Описание
            segment1View.isHidden = true
            segment2View.isHidden = true
            segment3View.isHidden = true
            segmentView.isHidden = false
            
        case 1:
            // Время
            segmentView.isHidden = true
            segment1View.isHidden = false
            segment2View.isHidden = true
            segment3View.isHidden = true
        case 2:
            // Участники
            segmentView.isHidden = true
            segment1View.isHidden = true
            segment3View.isHidden = true
            segment2View.isHidden = false
        case 3:
            // Цена
            segmentView.isHidden = true
            segment1View.isHidden = true
            segment3View.isHidden = false
            segment2View.isHidden = true
            
        default:
            break
        }
        viewDidLayoutSubviews()
    }
}
