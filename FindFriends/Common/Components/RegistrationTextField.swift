import UIKit

enum TextFieldType {
    case name
    case lastName
    case email
    case password
    case confirmPassword
    case date
}

final class RegistrationTextField: UITextField {
    
    var type: TextFieldType
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.font = .regular11
        label.textColor = .App.error
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .App.separator
        return view
    }()
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        button.imageView?.tintColor = .Text.primary
        button.setImage(.Symbols.closedEye, for: .normal)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    init(placeholder text: String, type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        
        setupViews(placeholder: text, type: type)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWarningLabel(_ text: String) {
        warningLabel.text = text
        warningLabel.isHidden = false
        separator.backgroundColor = .App.error
        textColor = .App.error
        attributedPlaceholder = attributedText(attributedPlaceholder?.string ?? "", with: .App.error)
    }
    
    func hideWarningLabel() {
        warningLabel.text = ""
        warningLabel.isHidden = true
        separator.backgroundColor = .App.separator
        textColor = .Text.primary
        attributedPlaceholder = attributedText(attributedPlaceholder?.string ?? "", with: .Text.placeholder)
    }
    
    func showWarningForDate(_ text: String) {
        warningLabel.text = text
        warningLabel.isHidden = false
        separator.backgroundColor = .App.error
    }

    private func setupViews(placeholder text: String, type: TextFieldType) {
        font = .regular17
        textColor = .Text.primary
        attributedPlaceholder = attributedText(text, with: .Text.placeholder)
        
        if type == .password || type == .confirmPassword {
            isSecureTextEntry = true
            rightViewMode = .always
            rightView = showPasswordButton
            addTarget(self, action: #selector(showToggleButton), for: .editingChanged)
        }
    }
    
    private func setupLayout() {
        addSubviewWithoutAutoresizingMask(separator)
        addSubviewWithoutAutoresizingMask(warningLabel)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            warningLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 2),
            warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    private func attributedText(_ text: String, with color: UIColor) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color,
                .font: UIFont.regular17
        ])
    }
    
    @objc private func showPassword() {
        isSecureTextEntry.toggle()
        showPasswordButton.setImage(
            isSecureTextEntry ? .Symbols.closedEye : .Symbols.openEye,
            for: .normal
        )
    }
    
    @objc private func showToggleButton() {
        if let text = text {
            showPasswordButton.isHidden = text.isEmpty ? true : false
        }
    }
}
