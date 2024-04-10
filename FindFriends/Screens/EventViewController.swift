import UIKit

final class EventViewController: UIViewController {
    
    private let emptyEvent: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named:"austronaut")
        return image
    }()
    
    private let emptyEventText: UILabel = {
        let label = UILabel()
        label.text = "У вас пока нет созданных\nмероприятий"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeEventLabel: UILabel = {
        let label = UILabel()
        label.text = "Создайте мероприятие, чтобы им можно \nбыло поделиться с другом и весело \nпровести время вместе"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "mainOrange")
        button.layer.cornerRadius = 10
        
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 15, right: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        let attributedString = NSMutableAttributedString(string: "+", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white])
        attributedString.append(NSAttributedString(string: " Создать", attributes: attributes))
        button.setAttributedTitle(attributedString, for: .normal)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
        setupNavigationBarSeparator()
    }
    private func setupNavigationBarSeparator() {
        
        let navBarSeparator = UIView()
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
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Мероприятия"
        titleLabel.font = .semibold17
        titleLabel.textColor = UIColor(named: "primeDark")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = titleLabel
    }
    
    private func setupUI() {
        view.addSubview(emptyEvent)
        view.addSubview(emptyEventText)
        view.addSubview(welcomeEventLabel)
        view.addSubview(createButton)
        setupConstraint()
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            emptyEvent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyEvent.topAnchor.constraint(equalTo: view.topAnchor, constant: 167),
            
            emptyEventText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyEventText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyEventText.topAnchor.constraint(equalTo: emptyEvent.bottomAnchor, constant: 46),
            
            welcomeEventLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeEventLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            welcomeEventLabel.topAnchor.constraint(equalTo: emptyEventText.bottomAnchor, constant: 24),
            welcomeEventLabel.heightAnchor.constraint(equalToConstant: 66),
            
            createButton.topAnchor.constraint(equalTo:  welcomeEventLabel.bottomAnchor, constant: 62),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            createButton.widthAnchor.constraint(equalToConstant: 122),
            createButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    @objc private func createButtonTapped() {
        let createEventVC = CreateEventViewController()
        createEventVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createEventVC, animated: true)
    }
}

