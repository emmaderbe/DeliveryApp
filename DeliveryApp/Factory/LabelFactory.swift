import UIKit

struct LabelFactory {
    static func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createSubtitleLabel(with text: String) -> UILabel {
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
    
    static func createCategoryLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.text = text
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "AccentGrey")
        label.textAlignment = .left
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
