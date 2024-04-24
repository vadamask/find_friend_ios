import UIKit
import Combine

final class EditMyProfileViewController: UIViewController {
    
    private var viewModel = EditMyProfileViewModel()
    weak var delegate: PhotoViewDelegate?
    private var cancellables: Set<AnyCancellable> = []
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 1500)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
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
    
    private lazy var editProfilePhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(.Symbols.pencil, for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .Buttons.active
        button.layer.bounds.size.height = 44
        button.layer.cornerRadius = button.layer.bounds.height / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapEditPhotoButton), for: .touchUpInside)
        button.isUserInteractionEnabled = true
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
        var text = "Имя*"
        let asterix = "*"
        let range = (text as NSString).range(of: asterix)
        let attributedText = NSMutableAttributedString.init(string: text)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Text.primary, range: range)
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var firstNameTextField: UITextField = {
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
        return textField
    }()
    
    private lazy var secondName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let text = "Фамилия*"
        let asterix = "*"
        let range = (text as NSString).range(of: asterix)
        let attributedText = NSMutableAttributedString.init(string: text)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Text.primary, range: range)
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var secondNameTextField: UITextField = {
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
        return textField
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let text = "Дата рождения*"
        let asterix = "*"
        let range = (text as NSString).range(of: asterix)
        let attributedText = NSMutableAttributedString.init(string: text)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Text.primary, range: range)
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var datePickTextField: RegistrationTextField = {
        let datePicker = RegistrationTextField(placeholder: "ДД.ММ.ГГГГ", type: .date)
        datePicker.keyboardType = .numberPad
        datePicker.clearButtonMode = .whileEditing
        datePicker.delegate = self
        return datePicker
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Пол*"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var genderManButton: GenderSelectionButton = {
        let button = GenderSelectionButton(text: "Мужской")
        button.setImage(.Symbols.orangeEmptyCircle, for: .normal)
        button.addTarget(self, action: #selector(genderManSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var genderWomanButton: GenderSelectionButton = {
        let button = GenderSelectionButton(text: "Женский")
        button.setImage(.Symbols.orangeEmptyCircle, for: .normal)
        button.addTarget(self, action: #selector(genderWomanSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 30
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var saveButton = PrimeOrangeButton(text: "Сохранить", isEnabled: false)
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш город"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var cityPickTextField: RegistrationTextField = {
        let datePicker = RegistrationTextField(placeholder: "Выберете город", type: .name)
        datePicker.keyboardType = .numberPad
        datePicker.clearButtonMode = .whileEditing
        datePicker.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapSelectCityButton)))
        datePicker.isEnabled = false
        return datePicker
    }()
    
    private lazy var workView = SettingProfileView(firstLabelText: "Работа",
                                                   firstLabelFont: 17,
                                                   secondLabelText: "Кратко напишите о себе кем работаете")
    
    private lazy var workTextField: UITextField = {
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
        return textField
    }()
    
    private lazy var profileGoalsView: SettingProfileView = {
        let view = SettingProfileView(firstLabelText: "Цель поиска друга",
                                      firstLabelFont: 17,
                                      secondLabelText: "Коротко напишите почему вы ищите друга")
        return view
    }()
    
    private lazy var profileGoalsTextView: UITextField = {
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
        return textField
    }()
    
    private lazy var socialLabel: SettingProfileView = {
        let label = SettingProfileView(firstLabelText: "Ник в соцсетях (Видят только друзья)",
                                       firstLabelFont: 17,
                                       secondLabelText: "")
        return label
    }()
    
    private lazy var vkView: CustomView = {
            let view = CustomView()
            view.firstLabel.text = "Вконтакте"
            view.firstLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            view.secondLabel.text = "Вставьте сюда ID вашего аккаунта в ВК."
            view.secondLabel.textColor = .Text.caption
            return view
    }()
    
    private lazy var vkTextView: UITextField = {
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
        return textField
    }()
    
    private lazy var tgView: CustomView = {
        let view = CustomView()
        view.firstLabel.text = "Телеграм"
        view.firstLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        view.secondLabel.text = "Вставьте сюда ссылку на ваш Telegram."
        view.secondLabel.textColor = .Text.caption
        return view
    }()
    
    private lazy var tgTextView: UITextField = {
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
        return textField
    }()
    
    private lazy var aboutMyself = SettingProfileView(firstLabelText: "О себе",
                                                      firstLabelFont: 17,
                                                      secondLabelText: "Коротко напишите о себе.")
    
    private lazy var aboutMyselfTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .Background.field
        textView.layer.cornerRadius = 12
        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return textView
    }()
    
    private lazy var interestsView = SettingProfileView(firstLabelText: "Интересы",
                                                        firstLabelFont: 17,
                                                        secondLabelText: "Добавляйте и удаляйте свои интересы.")
    
    private (set) lazy var tagsCollectionView = {
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: columnLayout)
        collectionView.collectionViewLayout = columnLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(InterestsCell.self)
        return collectionView
    }()
    
    private lazy var editInterestButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .black
        button.setImage(.Symbols.pencil, for: .normal)
        return button
    }()
    
    private lazy var seeMoreInterestLabel: UILabel = {
        let label = UILabel()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Показать еще 8", attributes: underlineAttribute)
        label.attributedText = underlineAttributedString
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        applyConstrainst()
        bind()
        datePickTextField.hideWarningLabel()
    }
    
    private func addView() {
        view.addSubview(scrollView)
        [avatarView, editProfilePhotoButton, editProfileLabel, firstName, firstNameTextField, secondName, secondNameTextField, birthdayLabel, datePickTextField, genderLabel, genderManButton, genderWomanButton, stackView, saveButton, cityLabel, cityPickTextField, workView, workTextField, profileGoalsView, profileGoalsTextView,socialLabel, vkView, vkTextView, tgView, tgTextView, aboutMyself, aboutMyselfTextView, interestsView, tagsCollectionView, editInterestButton, seeMoreInterestLabel].forEach(scrollView.addSubviewWithoutAutoresizingMask(_:))
        [genderManButton, genderWomanButton].forEach(stackView.addArrangedSubview(_:))
        
    }
    
    private func applyConstrainst() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 70),
            avatarView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarView.frame.width),
            avatarView.heightAnchor.constraint(equalToConstant: avatarView.frame.height),
            editProfilePhotoButton.heightAnchor.constraint(equalToConstant: 44),
            editProfilePhotoButton.widthAnchor.constraint(equalToConstant: 44),
            editProfilePhotoButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: 50),
            editProfilePhotoButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor, constant: 60),
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
            datePickTextField.heightAnchor.constraint(equalToConstant: 44),
            genderLabel.topAnchor.constraint(equalTo: datePickTextField.bottomAnchor, constant: 30),
            genderLabel.leadingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -120),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            cityLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 30),
            cityLabel.leadingAnchor.constraint(equalTo: firstName.leadingAnchor),
            cityPickTextField.leadingAnchor.constraint(equalTo: datePickTextField.leadingAnchor),
            cityPickTextField.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            cityPickTextField.trailingAnchor.constraint(equalTo: datePickTextField.trailingAnchor),
            cityPickTextField.heightAnchor.constraint(equalToConstant: 44),
            workView.topAnchor.constraint(equalTo: cityPickTextField.bottomAnchor, constant: 40),
            workView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            workView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            workTextField.topAnchor.constraint(equalTo: workView.bottomAnchor, constant: 16),
            workTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            workTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            workTextField.heightAnchor.constraint(equalToConstant: 44),
            profileGoalsView.topAnchor.constraint(equalTo: workTextField.bottomAnchor, constant: 30),
            profileGoalsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileGoalsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileGoalsTextView.topAnchor.constraint(equalTo: profileGoalsView.bottomAnchor, constant: 16),
            profileGoalsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            profileGoalsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            profileGoalsTextView.heightAnchor.constraint(equalToConstant: 44),
            socialLabel.topAnchor.constraint(equalTo: profileGoalsTextView.bottomAnchor, constant: 30),
            socialLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            socialLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vkView.topAnchor.constraint(equalTo: socialLabel.bottomAnchor),
            vkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vkTextView.topAnchor.constraint(equalTo: vkView.bottomAnchor, constant: 16),
            vkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            vkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            vkTextView.heightAnchor.constraint(equalToConstant: 44),
            tgView.topAnchor.constraint(equalTo: vkTextView.bottomAnchor, constant: 20),
            tgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tgTextView.topAnchor.constraint(equalTo: tgView.bottomAnchor, constant: 16),
            tgTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tgTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tgTextView.heightAnchor.constraint(equalToConstant: 44),
            aboutMyself.topAnchor.constraint(equalTo: tgTextView.bottomAnchor, constant: 30),
            aboutMyself.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aboutMyself.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aboutMyselfTextView.topAnchor.constraint(equalTo: aboutMyself.bottomAnchor, constant: 16),
            aboutMyselfTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            aboutMyselfTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            aboutMyselfTextView.heightAnchor.constraint(equalToConstant: 100),
            interestsView.topAnchor.constraint(equalTo: aboutMyselfTextView.bottomAnchor, constant: 30),
            interestsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            interestsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editInterestButton.topAnchor.constraint(equalTo: interestsView.topAnchor, constant: 30),
            editInterestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tagsCollectionView.topAnchor.constraint(equalTo: interestsView.bottomAnchor),
            tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 230),
            seeMoreInterestLabel.bottomAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: -20),
            seeMoreInterestLabel.trailingAnchor.constraint(equalTo: tagsCollectionView.trailingAnchor, constant: -60)
        ])
    }
    
    private func bind() {
        viewModel.$selectedGenderInSetting
            .sink { [weak self] gender in
                if gender != nil {
                    self?.saveButtonOff()
                    switch gender {
                    case .man:
                        self?.isManSelected(true)
                    case .woman:
                        self?.isManSelected(false)
                    default:
                        return
                    }
                } else {
                    self?.saveButtonOff()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$buttonAndError
            .sink { [weak self] dateIsCorrect in
                if dateIsCorrect {
                    self?.datePickTextField.hideWarningLabel()
                    self?.saveButtonOn()
                } else {
                    self?.datePickTextField.showWarningForDate("Недопустимое значение")
                    self?.saveButtonOff()
                }
            }
            .store(in: &cancellables)
        viewModel.$textFieldText
            .sink { [weak self] text in
                self?.datePickTextField.text = text
            }
            .store(in: &cancellables)
    }
    
    private func isManSelected(_ bool: Bool) {
        genderManButton.isSelectedInSetting(bool ? true : false)
        genderWomanButton.isSelectedInSetting(bool ? false : true)
    }
    
    func saveButtonOff() {
        saveButton.isEnabled = false
        saveButton.backgroundColor = .lightOrange
    }
    
    func saveButtonOn() {
        saveButton.isEnabled = true
        saveButton.backgroundColor = .mainOrange
    }
    
    @objc private func genderManSelected() {
        viewModel.change(gender: .man)
    }
    
    @objc private func genderWomanSelected() {
        viewModel.change(gender: .woman)
    }
    
    @objc private func didTapSelectCityButton() {
        
    }
    
    @objc private func didTapEditPhotoButton() {
        showImagePickerControleActionSheet()
    }
}

extension EditMyProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InterestsCell = tagsCollectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCell(with: InterestsCellViewModel(id: 0, name: "Спорт"))
        cell.contentView.layer.borderWidth = 0
        cell.isSelected = false
        cell.contentView.backgroundColor = .Background.interest
        return cell
    }
}

extension EditMyProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionLayout.spaceBetweenColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CollectionLayout.topOffsetCell, left: CollectionLayout.leadingOffsetCell, bottom: 10, right: CollectionLayout.trailingOffsetCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionLayout.spaceBetweenRows
    }
}

extension EditMyProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func showImagePickerControleActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.schoosePicker(sourceType: .camera)
            } else {print("CКамера недоступна") }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (action:UIAlertAction) in
            self.schoosePicker(sourceType: .photoLibrary)}))
        actionSheet.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    
    func schoosePicker(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            saveImage(editedImage)
            avatarView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarView.image = originalImage
            saveImage(originalImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else
        {
            return
        }
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageUrl = documentsURL.appendingPathComponent("avatar.png")
        do {
            try data.write(to: imageUrl)
        } catch {
            print("Ошибка сохранения изображения")
        }
    }
}

extension EditMyProfileViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        let shouldChangeCharactersIn = viewModel.shouldChangeCharactersIn(text: text, range: range, replacementString: string)
        
        if viewModel.shouldHideKeyboard() {
            textField.text = NSString(string: text).replacingCharacters(in: range, with: string)
            textField.resignFirstResponder()
        }
        
        return shouldChangeCharactersIn
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        datePickTextField.hideWarningLabel()
        return true
    }
}
