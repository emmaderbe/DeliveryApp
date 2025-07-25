import UIKit

final class PriceButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PriceButton {
    func setupUI() {
        self.setTitleColor(UIColor(named: "AccentPink"), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor(named: "AccentPink")?.cgColor
        self.layer.borderWidth = 1
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

