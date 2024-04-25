import UIKit

final class CaptionButton: UIButton {
    init(text: String?) {
        super.init(frame: .zero)
        titleLabel?.font = .semibold17
        setTitleColor(.Text.primary, for: .normal)
        backgroundColor = .clear
        setTitle(text, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
