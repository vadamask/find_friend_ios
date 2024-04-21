import UIKit
import Combine

final class GenderView: BaseFillProfileView {
    private let viewModel: GenderViewModel
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 52
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var genderManImageView: UIImageView = UIImageView(image: .Images.boyFace)
    private lazy var genderWomanImageView: UIImageView = UIImageView(image: .Images.girlFace)
    private let genderManButton = GenderSelectionButton(text: "Мужской")
    private let genderWomanButton = GenderSelectionButton(text: "Женский")
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: GenderViewModel) {
        self.viewModel = viewModel
        super.init(
            header: "Ваш пол",
            subheader: "Влияет на события, \n которые Вам будут доступны",
            passButtonHidden: true
        )
        
        setupViews()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GenderView {
    func bind() {
        viewModel.$selectedGender
            .sink { [weak self] gender in
                if gender != nil {
                    self?.nextButton.isEnabled = true
                    self?.nextButton.backgroundColor = .mainOrange
                    switch gender {
                    case .man:
                        self?.isManSelected(true)
                    case .woman:
                        self?.isManSelected(false)
                    default:
                        return
                    }
                } else {
                    self?.nextButton.backgroundColor = .lightOrange
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func genderManSelected() {
        viewModel.change(gender: .man)
    }
    @objc
    private func genderWomanSelected() {
        viewModel.change(gender: .woman)
    }
    private func isManSelected(_ bool: Bool) {
        genderManButton.isSelected(bool ? true : false)
        genderWomanButton.isSelected(bool ? false : true)
    }
    
    @objc
    private func nextButtonTap() {
        viewModel.nextButtonTapped()
    }
    
    func setupViews() {
        backgroundColor = .white
        genderWomanButton.addTarget(self, action: #selector(genderWomanSelected), for: .touchUpInside)
        genderManButton.addTarget(self, action: #selector(genderManSelected), for: .touchUpInside)
        
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTap), for: .touchUpInside)
    }
    
    func setupLayout() {
        addSubviewWithoutAutoresizingMask(stackView)
        stackView.addArrangedSubview(genderWomanButton)
        genderWomanButton.addSubviewWithoutAutoresizingMask(genderWomanImageView)
        stackView.addArrangedSubview(genderManButton)
        genderManButton.addSubviewWithoutAutoresizingMask(genderManImageView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: screenHeader.bottomAnchor, constant: 74),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 122),
            
            genderWomanButton.widthAnchor.constraint(equalToConstant: 97),
            genderWomanButton.heightAnchor.constraint(equalToConstant: 122),
            genderWomanImageView.centerXAnchor.constraint(equalTo: genderWomanButton.centerXAnchor),
            genderWomanImageView.topAnchor.constraint(equalTo: genderWomanButton.topAnchor, constant: 5),
            
            genderManButton.widthAnchor.constraint(equalToConstant: 97),
            genderWomanButton.heightAnchor.constraint(equalToConstant: 122),
            genderManImageView.centerXAnchor.constraint(equalTo: genderManButton.centerXAnchor),
            genderManImageView.topAnchor.constraint(equalTo: genderManButton.topAnchor, constant: 5)
        ])
    }
}

