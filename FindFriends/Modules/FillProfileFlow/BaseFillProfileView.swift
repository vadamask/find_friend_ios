import SnapKit
import UIKit

class BaseFillProfileView: UIView {
    
    var header: UILabel = {
        let label = UILabel()
        label.font = .medium24
        label.textColor = .Text.primary
        return label
    }()
    
    var caption: UILabel?
    var nextButton = PrimeOrangeButton(text: "Продолжить")
    var captionButton: CaptionButton?
    
    init(header: String, caption: String? = nil, captionButton: String? = nil) {
        super.init(frame: .zero)
        self.header.text = header
        
        if let caption {
            self.caption = {
                let label = UILabel()
                label.text = caption
                label.font = .regular16
                label.textColor = .Text.caption
                label.numberOfLines = 2
                label.textAlignment = .center
                return label
            }()
        }
    
        if let captionButton {
            self.captionButton = CaptionButton(text: captionButton)
        }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        addSubview(header)
        addSubview(nextButton)
        
        header.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(36)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.height.equalTo(48)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-68)
        }
        
        if let caption {
            addSubview(caption)
            
            caption.snp.makeConstraints { make in
                make.top.equalTo(header.snp.bottom)
                make.centerX.equalToSuperview()
            }
        }
        
        if let captionButton {
            addSubview(captionButton)
            
            captionButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(safeAreaLayoutGuide).offset(-4)
            }
        }
    }
}
