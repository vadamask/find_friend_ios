import UIKit

final class SettingProfileView: UIView {
    
    private lazy var separatorLine: DashedView = {
        let line = DashedView()
        line.config = .init(color: .App.separator, dashLength: 2, dashGap: 2)
        return line
    }()
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .Text.caption
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .label
        textField.backgroundColor = .Background.field
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.isEnabled = true
        return textField
    }()
    
    init(firstLabelText: String, firstLabelFont: CGFloat, secondLabelText: String) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLabel(firstLabelText: firstLabelText, firstLabelFont: firstLabelFont, secondLabelText: secondLabelText)
        addView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(firstLabelText: String, firstLabelFont: CGFloat, secondLabelText: String) {
        firstLabel.text = firstLabelText
        firstLabel.font = UIFont.systemFont(ofSize: firstLabelFont)
        secondLabel.text = secondLabelText
    }
    
    private func addView() {
        [separatorLine, firstLabel, secondLabel].forEach(addSubviewWithoutAutoresizingMask(_:))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            firstLabel.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 30),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 12),
            secondLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            secondLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
//            textField.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 12),
//            textField.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
//            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
