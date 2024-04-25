import UIKit

final class LoadingIndicator: UIImageView {
    
    init() {
        super.init(image: .Symbols.loadingIndicator)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        DispatchQueue.main.async {
            self.isHidden = false
            self.window?.isUserInteractionEnabled = false
        }
        
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: [.repeat, .calculationModeLinear]) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.transform = CGAffineTransform(rotationAngle: .pi)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                self.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }
        }

    }
    
    func hide() {
        DispatchQueue.main.async {
            self.isHidden = true
            self.window?.isUserInteractionEnabled = true
            self.stopAnimating()
            self.transform = .identity
        }
    }
}
