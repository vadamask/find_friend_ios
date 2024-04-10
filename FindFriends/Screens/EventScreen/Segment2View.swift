import UIKit

class Segment2View: UIView {
    
    private lazy var anyButton: UIButton = self.createRadioButton(withTitle: "Любой")
    private lazy var femaleButton: UIButton = self.createRadioButton(withTitle: "Женский")
    private lazy var maleButton: UIButton = self.createRadioButton(withTitle: "Мужской")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        anyButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        maleButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        
        setupParticipantUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let participantLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество участников"
        label.textAlignment = .left
        label.font = .semibold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionParticipantText: UILabel = {
        let label = UILabel()
        label.text = "Укажите сколько человек вы планируете позвать \nна мероприятие"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.text = "От"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.text = "До"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fromTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let toTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let separator1: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "borderGray")
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    private let separator2: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "borderGray")
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Возраст"
        label.textAlignment = .left
        label.font = .semibold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionAge: UILabel = {
        let label = UILabel()
        label.text = "Укажите диапазон возраста участников, которых\nвы планируете пригласить на мероприятие."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fromAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "От"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "До"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fromAgeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let toAgeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "0"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    private let separator3: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "borderGray")
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    private let separator4: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "borderGray")
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Пол"
        label.textAlignment = .left
        label.font = .semibold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionGender: UILabel = {
        let label = UILabel()
        label.text = "Укажите пол участников, которые будут\nпринимать участие на мероприятии"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func createRadioButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: "radio_off"), for: .normal)
        button.setImage(UIImage(named: "radio_on"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupParticipantUI() {
        setupString()
        addSubview(participantLabel)
        addSubview(descriptionParticipantText)
        
        addSubview(fromLabel)
        addSubview(toLabel)
        addSubview(fromTextField)
        addSubview(toTextField)
        
        addSubview(separator1)
        addSubview(separator2)
        addSubview(ageLabel)
        addSubview(descriptionAge)
        
        addSubview(fromAgeLabel)
        addSubview(toAgeLabel)
        addSubview(fromAgeTextField)
        addSubview(toAgeTextField)
        
        addSubview(separator3)
        addSubview(separator4)
        addSubview(genderLabel)
        addSubview(descriptionGender)
        
        addSubview(anyButton)
        addSubview(femaleButton)
        addSubview(maleButton)
        anyButton.isSelected = true
        
        NSLayoutConstraint.activate([
            participantLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            participantLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            descriptionParticipantText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionParticipantText.topAnchor.constraint(equalTo: participantLabel.bottomAnchor, constant: 12),
            
            fromLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 81),
            fromLabel.topAnchor.constraint(equalTo: descriptionParticipantText.bottomAnchor, constant: 27),
            
            fromTextField.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: 10),
            fromTextField.widthAnchor.constraint(equalToConstant: 44),
            fromTextField.heightAnchor.constraint(equalToConstant: 22),
            fromTextField.topAnchor.constraint(equalTo: descriptionParticipantText.bottomAnchor, constant: 27),
            fromTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -201),
            
            toLabel.leadingAnchor.constraint(equalTo: fromTextField.trailingAnchor, constant: 60),
            toLabel.topAnchor.constraint(equalTo: descriptionParticipantText.bottomAnchor, constant: 27),
            
            toTextField.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor, constant: 10),
            toTextField.widthAnchor.constraint(equalToConstant: 44),
            toTextField.heightAnchor.constraint(equalToConstant: 22),
            toTextField.topAnchor.constraint(equalTo: descriptionParticipantText.bottomAnchor, constant: 27),
            
            separator1.topAnchor.constraint(equalTo: fromTextField.bottomAnchor, constant: 11),
            separator1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 81),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            separator1.widthAnchor.constraint(equalToConstant: 92),
            
            separator2.topAnchor.constraint(equalTo: fromTextField.bottomAnchor, constant: 11),
            separator2.leadingAnchor.constraint(equalTo: separator1.trailingAnchor, constant: 44),
            separator2.widthAnchor.constraint(equalToConstant: 92),
            separator2.heightAnchor.constraint(equalToConstant: 1),
            
            ageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            ageLabel.topAnchor.constraint(equalTo: descriptionParticipantText.bottomAnchor, constant: 100),
            
            descriptionAge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionAge.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 10),
            
            
            fromAgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 81),
            fromAgeLabel.topAnchor.constraint(equalTo: descriptionAge.bottomAnchor, constant: 27),
            
            fromAgeTextField.leadingAnchor.constraint(equalTo: fromAgeLabel.trailingAnchor, constant: 10),
            fromAgeTextField.widthAnchor.constraint(equalToConstant: 44),
            fromAgeTextField.heightAnchor.constraint(equalToConstant: 22),
            fromAgeTextField.topAnchor.constraint(equalTo: descriptionAge.bottomAnchor, constant: 27),
            
            toAgeLabel.leadingAnchor.constraint(equalTo: fromAgeTextField.trailingAnchor, constant: 60),
            toAgeLabel.topAnchor.constraint(equalTo: descriptionAge.bottomAnchor, constant: 27),
            
            toAgeTextField.leadingAnchor.constraint(equalTo: toAgeLabel.trailingAnchor, constant: 10),
            toAgeTextField.widthAnchor.constraint(equalToConstant: 44),
            toAgeTextField.heightAnchor.constraint(equalToConstant: 22),
            toAgeTextField.topAnchor.constraint(equalTo: descriptionAge.bottomAnchor, constant: 27),
            
            separator3.topAnchor.constraint(equalTo: fromAgeTextField.bottomAnchor, constant: 11),
            separator3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 81),
            separator3.heightAnchor.constraint(equalToConstant: 1),
            separator3.widthAnchor.constraint(equalToConstant: 92),
            
            separator4.topAnchor.constraint(equalTo: fromAgeTextField.bottomAnchor, constant: 11),
            separator4.leadingAnchor.constraint(equalTo: separator3.trailingAnchor, constant: 44),
            separator4.widthAnchor.constraint(equalToConstant: 92),
            separator4.heightAnchor.constraint(equalToConstant: 1),
            
            genderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            genderLabel.topAnchor.constraint(equalTo: descriptionAge.bottomAnchor, constant: 100),
            
            descriptionGender.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionGender.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            
            anyButton.topAnchor.constraint(equalTo: descriptionGender.bottomAnchor, constant: 16),
            anyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            anyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            femaleButton.topAnchor.constraint(equalTo: anyButton.bottomAnchor, constant: 10),
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            femaleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            maleButton.topAnchor.constraint(equalTo: femaleButton.bottomAnchor, constant: 10),
            maleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            maleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            maleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
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
        let attributedStringForParticipantLabel = createAttributedStringForTitle(withTitle: "Количество участников")
        participantLabel.attributedText = attributedStringForParticipantLabel
        
        let attributedStringForAgeLabel = createAttributedStringForTitle(withTitle: "Возраст")
        ageLabel.attributedText = attributedStringForAgeLabel
        
        let attributedStringForGenderLabel = createAttributedStringForTitle(withTitle: "Пол")
        genderLabel.attributedText = attributedStringForGenderLabel
    }
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        anyButton.isSelected = false
        femaleButton.isSelected = false
        maleButton.isSelected = false
        
        sender.isSelected = true
    }
}
