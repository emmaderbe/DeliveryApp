import UIKit

final class MenuCell: UICollectionViewCell {
    
    private let dishImageView = ImageFactory.createImageCell()
    private let firstStack = StackFactory.createVerticalStack(with: 16)
    private let secondStack = StackFactory.createVerticalStack(with: 8)
    private let nameLabel = LabelFactory.createTitleLabel()
    private let descriptionLabel = LabelFactory.createDescriptionLabel()
    private let priceButtonContainer = BackgroundViewFactory.createContentWrapper()
    private let priceButton = PriceButton(title: "")
    
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

private extension MenuCell {
    func setupView() {
        contentView.backgroundColor = .clear
        
        [dishImageView, firstStack].forEach( {contentView.addSubview($0)} )
        
        firstStack.alignment = .fill
        [secondStack, priceButtonContainer].forEach( { firstStack.addArrangedSubview($0)} )
        priceButtonContainer.addSubview(priceButton)
        
        [nameLabel, descriptionLabel].forEach( {secondStack.addArrangedSubview($0)} )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dishImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dishImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dishImageView.widthAnchor.constraint(equalToConstant: 132),
            dishImageView.heightAnchor.constraint(equalTo: dishImageView.widthAnchor),
            
            firstStack.leadingAnchor.constraint(equalTo: dishImageView.trailingAnchor, constant: 32),
            firstStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            firstStack.bottomAnchor.constraint(equalTo: dishImageView.bottomAnchor),
            
            priceButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.232),
            priceButton.trailingAnchor.constraint(equalTo: priceButtonContainer.trailingAnchor),
            priceButton.topAnchor.constraint(equalTo: priceButtonContainer.topAnchor),
            priceButton.bottomAnchor.constraint(equalTo: priceButtonContainer.bottomAnchor)
        ])
    }
}


// MARK: - Public configure method
extension MenuCell {
    func configure(with model: MenuItemModel) {
        dishImageView.image = model.image
        nameLabel.text = model.title
        descriptionLabel.text = model.description
        priceButton.setTitle("от \(model.price) ₽", for: .normal)
    }
}

extension MenuCell {
    static var identifier: String {
        String(describing: MenuCell.self)
    }
}
