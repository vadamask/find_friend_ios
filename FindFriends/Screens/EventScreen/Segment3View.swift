import UIKit

class Segment3View: UIView {
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Стоимость"
        label.textAlignment = .left
        label.font = .Semibold.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionPriceText: UILabel = {
        let label = UILabel()
        label.text = "Указывается цена на каждого участника\nотдельно. Если участие бесплатно, то укажите\nстоимость 0."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "₽"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "primeDark")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separator1: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "borderGray")
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    func setupPriceUI() {
        setupString()
        addSubview(priceLabel)
        addSubview(descriptionPriceText)
        addSubview(priceTextField)
        addSubview(currencyLabel)
        addSubview(separator1)
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            descriptionPriceText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionPriceText.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            
            priceTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 165),
            priceTextField.widthAnchor.constraint(equalToConstant: 44),
            priceTextField.heightAnchor.constraint(equalToConstant: 22),
            priceTextField.topAnchor.constraint(equalTo: descriptionPriceText.bottomAnchor, constant: 29),
            priceTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -170),
            
            currencyLabel.topAnchor.constraint(equalTo:  descriptionPriceText.bottomAnchor, constant: 29),
            currencyLabel.leadingAnchor.constraint(equalTo:   priceTextField.trailingAnchor, constant: 10),
            
            separator1.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 13),
            separator1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 144),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            separator1.widthAnchor.constraint(equalToConstant: 92),
            separator1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func createAttributedStringForTitle(withTitle title: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(title) ")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        
        let starString = NSAttributedString(string: "*", attributes: [
            .foregroundColor: UIColor(named: "mainOrange") ?? .orange
        ])
        attributedString.append(starString)
        
        return attributedString
    }
    
    private func setupString() {
        let attributedStringForPriceLabel = createAttributedStringForTitle(withTitle: "Стоимость")
        priceLabel.attributedText = attributedStringForPriceLabel
    }
}
