import SnapKit
import UIKit

final class NewPasswordSuccessView: BaseAuthView {

    private let viewModel: NewPasswordSuccessViewModel

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Images.greenCheckmark
        return imageView
    }()

    private let header: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.font = .bold34
        label.text = "Пароль сохранён"
        label.textAlignment = .center
        return label
    }()

    private let caption: UILabel = {
        let label = UILabel()
        label.textColor = .primeDark
        label.numberOfLines = 0
        label.font = .regular17
        label.text = "Поздравляем. Теперь вы можете войти в свой профиль, используя новый пароль."
        label.textAlignment = .center
        return label
    }()

    init(viewModel: NewPasswordSuccessViewModel) {
        self.viewModel = viewModel
        super.init(primeButton: "Вернуться ко входу")
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        primeButton.setEnabled(true)
        primeButton.addTarget(
            self,
            action: #selector(logInButtonTapped),
            for: .touchUpInside
        )
    }

    private func setupLayout() {
        scrollView.addSubview(imageView)
        scrollView.addSubview(header)
        scrollView.addSubview(caption)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-66)
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        caption.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(16)
            make.leading.trailing.equalTo(layoutMarginsGuide)
        }
    }

    @objc private func logInButtonTapped() {
        viewModel.didTapLogInButton()
    }
}

