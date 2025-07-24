import UIKit

final class AuthButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        // text
        self.setTitle(title, for: .normal)
        
        // ui
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthButton {
    func setupUI() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.layer.cornerRadius = 20
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
}

extension AuthButton {
    func updateAppearance(isEnabled: Bool) {
        self.backgroundColor = isEnabled ? UIColor(named: "AccentPink") : UIColor(named: "AccentPink")?.withAlphaComponent(0.4)
    }
}
