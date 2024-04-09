import UIKit

class SegmentView: UIView, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    weak var viewController: UIViewController?
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Заголовок"
        label.textAlignment = .left
        label.font = .Semibold.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionEventText: UILabel = {
        let label = UILabel()
        label.text = "Кратко напишите название мероприятия, чтобы \nдругим было легче понять о чем оно."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let captionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Например: Настольный теннис на улице"
        textField.backgroundColor = UIColor(named: "searchTextFieldBackground")
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 50"
        label.textColor = UIColor(named: "placeholder")
        label.font = .Regular.small11
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Тип"
        label.textAlignment = .left
        label.font = .Semibold.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTypeText: UILabel = {
        let label = UILabel()
        label.text = "Спортивное мероприятие, отдых или, может \nбыть, это мастер-класс? Кратко напишите тип."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Например: Активный отдых"
        textField.backgroundColor = UIColor(named: "searchTextFieldBackground")
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let typeLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 50"
        label.textColor = UIColor(named: "placeholder")
        label.font = .Regular.small11
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Подробности"
        label.textAlignment = .left
        label.font = .Semibold.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailTypeText: UILabel = {
        let label = UILabel()
        label.text = "Расскажите подробнее о мероприятии"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Например: Активный отдых"
        textField.backgroundColor = UIColor(named: "searchTextFieldBackground")
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    
    
    private let fotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото места проведения"
        label.textAlignment = .left
        label.font = .Semibold.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fotoTypeText: UILabel = {
        let label = UILabel()
        label.text = "Предложения с фото выглядят более\nпривлекательно"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let plusContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor(named: "borderGray")?.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = UIColor(named: "primeDark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupEventUI() {
        setupString()
        addSubview(captionLabel)
        addSubview(descriptionEventText)
        addSubview(captionTextField)
        addSubview(limitLabel)
        addSubview(typeLabel)
        addSubview(descriptionTypeText)
        addSubview(typeTextField)
        addSubview(typeLimitLabel)
        addSubview(detailLabel)
        addSubview(detailTypeText)
        addSubview(detailTextField)
        addSubview(fotoLabel)
        addSubview(fotoTypeText)
        addSubview(plusContainerView)
        addSubview(plusImageView)
        
        NSLayoutConstraint.activate([
            
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            captionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            descriptionEventText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionEventText.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 12),
            
            captionTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            captionTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            captionTextField.topAnchor.constraint(equalTo: descriptionEventText.bottomAnchor, constant: 16),
            captionTextField.heightAnchor.constraint(equalToConstant: 44),
            captionTextField.widthAnchor.constraint(equalToConstant: 358),
            
            limitLabel.trailingAnchor.constraint(equalTo: captionTextField.trailingAnchor, constant: -9),
            limitLabel.topAnchor.constraint(equalTo: captionTextField.bottomAnchor, constant: 2),
            
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeLabel.topAnchor.constraint(equalTo: limitLabel.bottomAnchor, constant: 19),
            
            descriptionTypeText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTypeText.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 12),
            
            typeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            typeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            typeTextField.topAnchor.constraint(equalTo: descriptionTypeText.bottomAnchor, constant: 16),
            typeTextField.heightAnchor.constraint(equalToConstant: 44),
            typeTextField.widthAnchor.constraint(equalToConstant: 358),
            
            typeLimitLabel.trailingAnchor.constraint(equalTo: typeTextField.trailingAnchor, constant: -9),
            typeLimitLabel.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: 2),
            
            detailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailLabel.topAnchor.constraint(equalTo: typeTextField.bottomAnchor, constant: 19),
            
            detailTypeText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailTypeText.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 12),
            
            detailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailTextField.topAnchor.constraint(equalTo: detailTypeText.bottomAnchor, constant: 16),
            detailTextField.heightAnchor.constraint(equalToConstant: 44),
            detailTextField.widthAnchor.constraint(equalToConstant: 358),
            
            fotoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fotoLabel.topAnchor.constraint(equalTo: detailTextField.bottomAnchor, constant: 36),
            
            fotoTypeText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fotoTypeText.topAnchor.constraint(equalTo: fotoLabel.bottomAnchor, constant: 12),
            
            
            plusContainerView.topAnchor.constraint(equalTo: fotoTypeText.bottomAnchor, constant: 24),
            plusContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            plusContainerView.widthAnchor.constraint(equalToConstant: 96),
            plusContainerView.heightAnchor.constraint(equalTo: plusContainerView.widthAnchor),
            plusContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            plusImageView.centerXAnchor.constraint(equalTo: plusContainerView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: plusContainerView.centerYAnchor),
            plusImageView.widthAnchor.constraint(equalToConstant: 32),
            plusImageView.heightAnchor.constraint(equalTo: plusImageView.widthAnchor),
            
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
        let attributedStringForCaptionLabel = createAttributedStringForTitle(withTitle: "Заголовок")
        captionLabel.attributedText = attributedStringForCaptionLabel
        
        let attributedStringForTypeLabel = createAttributedStringForTitle(withTitle: "Тип")
        typeLabel.attributedText = attributedStringForTypeLabel
        
        let attributedStringForDetailLabel = createAttributedStringForTitle(withTitle: "Подробности")
        detailLabel.attributedText = attributedStringForDetailLabel
    }
    
    func addTapGestureToPlusContainerView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(eventImageButtonTapped))
        plusContainerView.addGestureRecognizer(tapGesture)
    }
    
    @objc  func eventImageButtonTapped() {
        showImagePickerControleActionSheet()
    }
    
    private func showImagePickerControleActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.choosePicker(sourceType: .camera)
            } else {print("Камера недоступна") }
        }))
        actionSheet.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (action:UIAlertAction) in
            self.choosePicker(sourceType: .photoLibrary)}))
        actionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        if let viewController = viewController {
            viewController.present(actionSheet, animated: true)
        }
    }
    
    private func choosePicker(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        UINavigationBar.appearance().backgroundColor = .white
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        
        if let viewController = viewController {
            viewController.present(imagePickerController, animated: true)
        }
    }
}

