import UIKit

struct LabelFactory {
    static func createTitleLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createOrdinaryLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
