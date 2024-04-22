import UIKit

final class UnderlinedButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semibold15,
            .foregroundColor: UIColor.primeDark,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        setAttributedTitle(attributeString, for: .normal)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
