import UIKit

final class SearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.placeholder = "Поиск"
        self.searchBarStyle = .minimal
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: [
            .foregroundColor: UIColor.searchBar,
            .font: UIFont.regular17
        ])
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.searchTextField.textColor = .black
        self.backgroundColor = .searchTextFieldBackground
        for subview in self.searchTextField.subviews {
            subview.backgroundColor = .clear
            subview.alpha = 0
        }
    }
}
