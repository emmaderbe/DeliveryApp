import UIKit

final class BannerCell: UICollectionViewCell {
    private let bannerImageView = ImageFactory.createImageCell()
    
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
private extension BannerCell {
    func setupView() {
        self.layer.cornerRadius = 10
        contentView.addSubview(bannerImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension BannerCell {
    func configure(with image: UIImage?) {
        bannerImageView.image = image
    }
}

extension BannerCell {
    static var identifier: String {
        String(describing: BannerCell.self)
    }
}
