//
//  LoadingIndicator.swift
//  FindFriends
//
//  Created by Вадим Шишков on 18.04.2024.
//

import UIKit

final class LoadingIndicator: UIImageView {
    
    init() {
        super.init(image: UIImage(resource: .loadingIndicator))
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        isHidden = false
        window?.isUserInteractionEnabled = false
        
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
        isHidden = true
        window?.isUserInteractionEnabled = true
        stopAnimating()
        self.transform = .identity
    }
}
