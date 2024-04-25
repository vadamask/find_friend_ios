//
//  PrimeButton.swift
//  FindFriends
//
//  Created by Вадим Шишков on 15.02.2024.
//

import UIKit

final class PrimeOrangeButton: UIButton {
    init(text: String, isEnabled: Bool = false) {
        super.init(frame: .zero)
        self.isEnabled = isEnabled
        setTitle(text, for: .normal)
        layer.cornerRadius = 10
        titleLabel?.font = .semibold17
        setTitleColor(.white, for: .normal)
        backgroundColor = isEnabled ? .Buttons.active : .Buttons.inactive
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        backgroundColor = isEnabled ? .Buttons.active : .Buttons.inactive
    }
}
