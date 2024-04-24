//
//  WhiteBorderButton.swift
//  FindFriends
//
//  Created by Вадим Шишков on 19.02.2024.
//

import UIKit

final class WhiteBorderButton: UIButton {
    init(text: String) {
        super.init(frame: .zero)
        titleLabel?.font = .regular17
        setTitleColor(.Text.primary, for: .normal)
        backgroundColor = .white
        setTitle(text, for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.Buttons.active.cgColor
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
