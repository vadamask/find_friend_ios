import UIKit

class Segment1View: UIView {
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Начало события"
        label.textAlignment = .left
        label.font = .semibold17
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTimeText: UILabel = {
        let label = UILabel()
        label.text = "Укажите дату и время начала события, чтобы\nпользователи знали ко скольки нужно подойти."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor(named: "borderGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    func setupTimeUI() {
        setupString()
        addSubview(timeLabel)
        addSubview(descriptionTimeText)
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            descriptionTimeText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionTimeText.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12),
            
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: descriptionTimeText.bottomAnchor, constant: 16),
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func createAttributedStringForTitle(withTitle title: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(title) ")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        
        let starString = NSAttributedString(string: "*", attributes: [
            .foregroundColor: UIColor(named: "mainOrange") ?? .orange
        ])
        attributedString.append(starString)
        return attributedString
    }
    
    private  func setupString() {
        let attributedStringForTimeLabel = createAttributedStringForTitle(withTitle: "Начало события")
        timeLabel.attributedText = attributedStringForTimeLabel
    }
}
