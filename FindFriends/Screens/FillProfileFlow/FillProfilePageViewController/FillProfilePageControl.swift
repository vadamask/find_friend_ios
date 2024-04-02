//
//  CustomUIPageControl.swift
//  FindFriends
//
//  Created by Ognerub on 3/3/24.
//

import UIKit

final class FillProfilePageControl: UIPageControl {

    private let buttonHeight: CGFloat = 4.0
    private let buttonLeading: CGFloat = 0
    private let buttonSpacing: CGFloat = 8.0

    override var numberOfPages: Int {
        didSet {
            setupButtons()
        }
    }

    override var currentPage: Int {
        didSet {
            updateButtonSelection()
        }
    }

    private var buttons: [UIButton] = []
    private var buttonsViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButtons() {

        buttons.forEach {
            $0.removeFromSuperview()
        }
        buttons.removeAll()
        for _ in 0 ..< numberOfPages {
            let button = UIButton()
            button.backgroundColor = .clear
            buttons.append(button)
            addSubview(button)
            let buttonView = UIView()
            buttonView.backgroundColor = UIColor.white
            buttonView.layer.cornerRadius = 2
            buttonsViews.append(buttonView)
            button.insertSubview(buttonView, at: 0)

        }
        updateButtonLayout()
        updateButtonSelection()
    }

    private func updateButtonLayout() {

        let pagesCount = CGFloat(numberOfPages)
        let number = CGFloat(max(0, pagesCount - 1))
        let fullSpacing = number * buttonSpacing
        let fullWidth = frame.width - (buttonLeading * 2) - fullSpacing

        let autoWidth = fullWidth / pagesCount

        var totalWidth: CGFloat = pagesCount * autoWidth + fullSpacing

        if let lastButton = buttons.last {
            totalWidth += lastButton.frame.width
        }

        let startX = buttonLeading

        for (index, button) in buttons.enumerated() {
            let buttonFrameX = startX + CGFloat(index) * (autoWidth + buttonSpacing)

            button.frame = CGRect(x: buttonFrameX, y: 0, width: autoWidth, height: frame.height)
            buttonsViews[index].frame = CGRect(x: 0, y: 20, width: button.frame.width, height: buttonHeight)

            buttonsViews[index].isUserInteractionEnabled = false
        }
    }

    private func updateButtonSelection() {
        for (index, buttonViews) in buttonsViews.enumerated() {
            buttonViews.backgroundColor = (index == currentPage) ? UIColor(named: "lightOrange") : UIColor(named: "secondaryOrange")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateButtonLayout()
        updateButtonSelection()
    }
}

