import UIKit

final class CustomView : UIView {
    lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 4
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = true
        addView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        [firstLabel, secondLabel].forEach(addSubviewWithoutAutoresizingMask(_:))
    }
    
    private func addConstraints() {
            NSLayoutConstraint.activate([
                firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                firstLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
                secondLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
        }
    }
