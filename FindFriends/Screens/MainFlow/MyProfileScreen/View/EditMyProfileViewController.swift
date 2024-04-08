import UIKit
import Combine



final class EditMyProfileViewController: UIViewController {
    
    private var viewModel = EditMyProfileViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 1300)
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
//        button.configuration = .plain()
        button.setImage(.edit, for: .normal)
        button.imageView?.tintColor = .white
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
    
    private lazy var datePickTextField: RegistrationTextField = {
        let datePicker = RegistrationTextField(placeholder: "ДД.ММ.ГГГГ", type: .date)
        datePicker.keyboardType = .numberPad
        datePicker.clearButtonMode = .whileEditing
        return datePicker
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Пол"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var genderManButton: GenderSelectionButton = {
        let button = GenderSelectionButton(text: "Мужской")
        button.setImage(.cityUnselected, for: .normal)
        button.addTarget(self, action: #selector(genderManSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var genderWomanButton: GenderSelectionButton = {
        let button = GenderSelectionButton(text: "Женский")
        button.setImage(.cityUnselected, for: .normal)
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
        textField.backgroundColor = .searchTextFieldBackground
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
        textField.backgroundColor = .searchTextFieldBackground
        textField.layer.cornerRadius = 12
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.rightView = paddingView
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var socialLabel: SettingProfileView = {
        let label = SettingProfileView(firstLabelText: "Ник в соцсетях (Видят только друзья)", firstLabelFont: 17, secondLabelText: "")
        return label
    }()
    
    private lazy var vkView: CustomView = {
            let view = CustomView()
            view.firstLabel.text = "Вконтакте"
            view.firstLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            view.secondLabel.text = "Вставьте сюда ID вашего аккаунта в ВК."
            view.secondLabel.textColor = .borderGray
            return view
    }()
    
    private lazy var vkTextView: UITextField = {
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
    
    private lazy var tgView: CustomView = {
        let view = CustomView()
        view.firstLabel.text = "Телеграм"
        view.firstLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        view.secondLabel.text = "Вставьте сюда ссылку на ваш Telegram."
        view.secondLabel.textColor = .borderGray
        return view
    }()
    
    private lazy var tgTextView: UITextField = {
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
    
    private lazy var aboutMyself = SettingProfileView(firstLabelText: "О себе",
                                                      firstLabelFont: 17,
                                                      secondLabelText: "Коротко напишите о себе.")
    
    private lazy var aboutMyselfTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .searchTextFieldBackground
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
        collectionView.register(TagsCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var editInterestButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .black
        button.setImage(.edit, for: .normal)
        //button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
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
    }
    
    private func addView() {
        view.addSubview(scrollView)
        [avatarView, editButton, editProfileLabel, firstName, firstNameTextField, secondName, secondNameTextField, birthdayLabel, datePickTextField, genderLabel, genderManButton, genderWomanButton, stackView, saveButton, cityLabel, cityPickTextField, workView, workTextField, profileGoalsView, profileGoalsTextView,socialLabel, vkView, vkTextView, tgView, tgTextView, aboutMyself, aboutMyselfTextView, interestsView, tagsCollectionView, editInterestButton, seeMoreInterestLabel].forEach(scrollView.addSubviewWithoutAutoresizingMask(_:))
        [genderManButton, genderWomanButton].forEach(stackView.addArrangedSubview(_:))
        
    }
    
    private func applyConstrainst() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 70),
            avatarView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
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
                    self?.saveButton.isEnabled = true
                    self?.saveButton.backgroundColor = .mainOrange
                    switch gender {
                    case .man:
                        self?.isManSelected(true)
                    case .woman:
                        self?.isManSelected(false)
                    default:
                        return
                    }
                } else {
                    self?.saveButton.backgroundColor = .lightOrange
                }
            }
            .store(in: &cancellables)
    }
    
    private func isManSelected(_ bool: Bool) {
        genderManButton.isSelectedInSetting(bool ? true : false)
        genderWomanButton.isSelectedInSetting(bool ? false : true)
    }
    
    
    @objc
    private func genderManSelected() {
        viewModel.change(gender: .man)
    }
    
    @objc
    private func genderWomanSelected() {
        viewModel.change(gender: .woman)
    }
    
    @objc private func didTapSelectCityButton() {
        
    }
}

extension EditMyProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagsCollectionViewCell = tagsCollectionView.dequeueReusableCell(indexPath: indexPath)
        cell.setupCell(with: InterestsCellViewModel(id: 0, name: "Спорт"))
        cell.contentView.layer.borderWidth = 0
        cell.isSelected = false
        cell.contentView.backgroundColor = .selectedTag
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
