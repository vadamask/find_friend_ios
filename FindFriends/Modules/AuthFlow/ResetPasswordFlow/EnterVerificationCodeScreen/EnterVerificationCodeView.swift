import Combine
import SnapKit
import UIKit

final class EnterVerificationCodeView: BaseAuthView {
    
    private let viewModel: EnterVerificationCodeViewModel
    private var fields: [UITextField] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var header: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.font = .bold34
        label.text = "Введите код"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var caption: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.numberOfLines = 0
        label.font = .regular17
        label.textAlignment = .center
        label.text = "Мы отправили код на вашу почту\n\(viewModel.email)"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        for _ in 1...6 {
            let textField = UITextField()
            textField.backgroundColor = UIColor(resource: .searchTextFieldBackground)
            textField.layer.cornerRadius = 10
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
            textField.delegate = self
            stackView.addArrangedSubview(textField)
            fields.append(textField)
        }
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 12
        return stackView
    }()

    init(viewModel: EnterVerificationCodeViewModel) {
        self.viewModel = viewModel
        super.init(primeButton: "Подтвердить", captionButton: "Отправить код еще раз")
        
        setupViews()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        primeButton.addTarget(self, action: #selector(confirmButtonTapped), for:  .touchUpInside)
        captionButton.addTarget(self, action: #selector(sendCodeAgainButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        scrollView.addSubview(header)
        scrollView.addSubview(caption)
        scrollView.addSubview(stackView)
        
        header.snp.makeConstraints { make in
            make.top.equalTo(topDecoration.snp.bottom).offset(104)
            make.centerX.equalToSuperview()
        }
        
        caption.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(caption.snp.bottom).offset(24)
            make.height.equalTo(44)
            make.leading.equalToSuperview().offset(33)
            make.trailing.equalToSuperview().offset(-33)
        }
    }
    
    private func bind() {
        viewModel.$isFullfill
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isFullfill in
                primeButton.setEnabled(isFullfill)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [unowned self] isLoading in
                if isLoading {
                    loadingIndicator.show()
                } else {
                    loadingIndicator.hide()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func confirmButtonTapped() {
        viewModel.confirmButtonTapped()
    }
    
    @objc private func sendCodeAgainButtonTapped() {
        viewModel.sendCodeAgainButtonTapped()
    }
}

// MARK: - UITextField

extension EnterVerificationCodeView: UITextFieldDelegate {
    
    @objc private func textFieldDidChanged(_ textField: UITextField) {
        if let index = fields.firstIndex(of: textField) {
            if index < fields.count - 1 {
                let textField = fields[index + 1]
                textField.becomeFirstResponder()
            } else {
                fields[index].resignFirstResponder()
            }
            viewModel.fields[index].send(textField.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              !currentText.isEmpty else { return true }
        return string.isEmpty
    }
}
