import UIKit
import Combine

final class EditMyProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstrainst()
        datePickTextField.keyboardType = .numberPad
        datePickTextField.clearButtonMode = .whileEditing
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plugPhoto")
        view.tintColor = .lightGray
        view.layer.frame.size.height = 160
        view.contentMode = .center
        view.layer.frame.size.width = view.layer.frame.size.height
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setImage(.edit, for: .normal)
        button.backgroundColor = .mainOrange
        button.layer.bounds.size.height = 44
        button.layer.cornerRadius = button.layer.bounds.height / 2
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var editProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "Личная информация"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var firstName: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .searchTextFieldBackground
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var secondName: UILabel = {
        let label = UILabel()
        label.text = "Фамилия"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .searchTextFieldBackground
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата рождения"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private let datePickTextField: RegistrationTextField = {
        let datePicker = RegistrationTextField(placeholder: "ДД.ММ.ГГГГ", type: .date)
        return datePicker
    }()
    
    private func addView() {
        [avatarView, editButton, editProfileLabel, firstName, firstNameTextField, secondName, secondNameTextField, birthdayLabel, datePickTextField].forEach(view.addSubviewWithoutAutoresizingMask(_:))
    }
    
    private func applyConstrainst() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarView.frame.width),
            avatarView.heightAnchor.constraint(equalToConstant: avatarView.frame.height),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 44),
            editButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: 50),
            editButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor, constant: 60),
            editProfileLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 40),
            editProfileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            firstName.topAnchor.constraint(equalTo: editProfileLabel.bottomAnchor, constant: 12),
            firstName.leadingAnchor.constraint(equalTo: editProfileLabel.leadingAnchor),
            firstNameTextField.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 16),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 44),
            secondName.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 30),
            secondName.leadingAnchor.constraint(equalTo: firstName.leadingAnchor),
            secondNameTextField.topAnchor.constraint(equalTo: secondName.bottomAnchor, constant: 16),
            secondNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            secondNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 44),
            birthdayLabel.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 30),
            birthdayLabel.leadingAnchor.constraint(equalTo: firstName.leadingAnchor),
            datePickTextField.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 6),
            datePickTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            datePickTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            datePickTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
