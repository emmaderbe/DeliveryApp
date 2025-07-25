import UIKit

final class CategoryCell: UICollectionViewCell {
    private let titleLabel = LabelFactory.createCategoryLabel(with: "")
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension CategoryCell {
    func setupView() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}

// MARK: - Public
extension CategoryCell {
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            contentView.backgroundColor = UIColor(named: "AccentPink")?.withAlphaComponent(0.2)
            titleLabel.textColor = UIColor(named: "AccentPink")
            contentView.layer.borderWidth = 0    
            contentView.layer.borderColor = nil
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.borderColor = UIColor(named: "AccentPink")?.withAlphaComponent(0.4).cgColor
            contentView.layer.borderWidth = 1
            titleLabel.textColor = UIColor(named: "AccentPink")?.withAlphaComponent(0.4)
        }
    }
}

extension CategoryCell {
    static var identifier: String {
        String(describing: CategoryCell.self)
    }
}
