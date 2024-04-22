import SnapKit
import UIKit

class BaseAuthView: UIView {
    let loadingIndicator = LoadingIndicator()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .white
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let topDecoration: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Images.orangeWave
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let primeButton: PrimeOrangeButton
    let captionButton: CaptionButton

    init(primeButton: String, captionButton: String? = nil) {
        self.primeButton = PrimeOrangeButton(text: primeButton)
        self.captionButton = CaptionButton(text: captionButton)
        super.init(frame: .zero)
        
        self.primeButton.titleLabel?.text = primeButton
        self.captionButton.titleLabel?.text = captionButton
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
    }

    private func setupLayout() {
        addSubview(scrollView)
        addSubview(loadingIndicator)
        scrollView.addSubview(topDecoration)
        scrollView.addSubview(primeButton)
        scrollView.addSubview(captionButton)
        
        scrollView.contentLayoutGuide.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        topDecoration.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(scrollView)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        primeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(48)
            make.bottom.equalTo(scrollView).offset(-68)
        }
        
        captionButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.bottom.equalTo(scrollView).offset(-4)
        }
    }
}
