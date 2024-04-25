import UIKit
import Combine

final class GenderView: BaseFillProfileView {
    
    private let viewModel: GenderViewModel
    private let boy = GenderFace(.boy)
    private let girl = GenderFace(.girl)
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: GenderViewModel) {
        self.viewModel = viewModel
        super.init(
            header: "Ваш пол",
            caption: "Влияет на события, \n которые Вам будут доступны"
        )
        setupViews()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {
        viewModel.$selectedGender
            .sink { [unowned self] gender in
                switch gender {
                case .boy:
                    boy.isSelected = true
                    girl.isSelected = false
                    nextButton.setEnabled(true)
                case .girl:
                    boy.isSelected = false
                    girl.isSelected = true
                    nextButton.setEnabled(true)
                case nil:
                    boy.isSelected = false
                    girl.isSelected = false
                    nextButton.setEnabled(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupViews() {
        backgroundColor = .white
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        boy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(boyDidSelect)))
        girl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(girlDidSelect)))
    }
    
    func setupLayout() {
        addSubview(boy)
        addSubview(girl)
        
        girl.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 97, height: 122))
            make.top.equalTo(safeAreaLayoutGuide).offset(189)
            make.leading.equalTo(72)
        }
        
        boy.snp.makeConstraints { make in
            make.size.equalTo(girl)
            make.top.equalTo(girl)
            make.trailing.equalTo(-72)
            make.leading.equalTo(girl.snp.trailing).offset(52)
        }
    }
    
    @objc
    private func boyDidSelect() {
        viewModel.boyDidSelect()
    }
    
    @objc
    private func girlDidSelect() {
        viewModel.girlDidSelect()
    }
    
    @objc
    private func nextButtonTapped() {
        viewModel.nextButtonTapped()
    }
}

final private class GenderFace: UIView {
    var isSelected = false {
        didSet {
            backgroundColor = isSelected ? .Background.gender : .clear
        }
    }
    private let imageView: UIImageView
    private let label = UILabel()
    
    init(_ gender: Gender) {
        if case .boy = gender {
            imageView = UIImageView(image: .Images.boyFace)
            label.text = "Мужской"
        } else {
            imageView = UIImageView(image: .Images.girlFace)
            label.text = "Женский"
        }
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        layer.cornerRadius = 20
        label.font = .regular16
        label.textColor = .Text.primary
        label.textAlignment = .center
    }
    
    private func setupLayout() {
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(7)
            make.trailing.equalTo(-7)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(-17)
            make.leading.equalTo(7)
            make.trailing.equalTo(-7)
        }
    }
}
