import SnapKit
import UIKit

class BaseRegistrationView: UIView {
    let loadingIndicator = LoadingIndicator()
    
    let topDecoration: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .topDecoration
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .white
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private enum Constants {
        static let topDecorationInset: CGFloat = -0.3
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white
        addSubview(scrollView)
        addSubview(loadingIndicator)
        scrollView.addSubview(contentView)
        contentView.addSubview(topDecoration)
    }

    private func setupLayout() {
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        topDecoration.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(contentView)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
