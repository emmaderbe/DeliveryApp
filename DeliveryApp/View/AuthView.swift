import UIKit

final class AuthView: UIView {
    // MARK: - Private properties
    private let titleLabel = LabelFactory.createTitleLabel(with: "Авторизация")
    private let logoImageView = ImageFactory.makeLogoImageView()
    private let stackView = StackFactory.createVerticalStack(with: 8)
    private let loginTextField = AuthTextField(placeholder: "Логин",
                                               icon: .person)
    private let passwordTextField = AuthTextField(placeholder: "Пароль",
                                                  icon: .lock,
                                                  isSecure: true)
    private let backgroundView = BackgroundViewFactory.createBackground()
    private let contentWrapper = BackgroundViewFactory.createContentWrapper()
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.4)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Constraints properties
    private var logoTopConstraint: NSLayoutConstraint?
    private var backgroundHeightConstraint: NSLayoutConstraint?
    private var backgroundBottomConstraint: NSLayoutConstraint?
    private var contentWrapperToSafeAreaConstraint: NSLayoutConstraint?
    private var contentWrapperToBackgroundConstraint: NSLayoutConstraint?
    
    // MARK: - Intialization
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
private extension AuthView {
    func setupView() {
        backgroundColor = UIColor(named: "AccentBackground")
        
        [titleLabel,
         logoImageView,
         stackView,
         backgroundView].forEach( {addSubview($0)} )
        
        [loginTextField,
         passwordTextField].forEach( { stackView.addArrangedSubview($0)} )
        
        backgroundView.addSubview(contentWrapper)
        [loginButton].forEach( { contentWrapper.addSubview($0)} )
    }
    
    func setupConstraints() {
        logoTopConstraint = logoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 135)
        backgroundHeightConstraint = backgroundView.heightAnchor.constraint(equalToConstant: 118)
        backgroundBottomConstraint = backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        contentWrapperToSafeAreaConstraint = contentWrapper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        contentWrapperToBackgroundConstraint = contentWrapper.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        
        guard let logoTopConstraint,
              let backgroundHeightConstraint,
              let backgroundBottomConstraint,
              let contentWrapperToSafeAreaConstraint
        else { return }
        
        contentWrapperToSafeAreaConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14),
            
            logoTopConstraint,
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.32),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            backgroundHeightConstraint,
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBottomConstraint,
            
            contentWrapper.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            
            loginButton.centerYAnchor.constraint(equalTo: contentWrapper.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

// MARK: - Edit UI after keyboard
extension AuthView {
    func adjustBackgroundForKeyboard(height: CGFloat, duration: TimeInterval, curve: UIView.AnimationCurve) {
        let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.applyLayout(state: height == 0 ? .normal : .compact,
                             keyboardHeight: height)
        }
    }
    
    func activateContentWrapperSafeArea() {
        contentWrapperToBackgroundConstraint?.isActive = false
        contentWrapperToSafeAreaConstraint?.isActive = true
    }
    
    func activateContentWrapperBackground() {
        contentWrapperToSafeAreaConstraint?.isActive = false
        contentWrapperToBackgroundConstraint?.isActive = true
    }
    
}

// MARK: - Layout states
private extension AuthView {
    enum LayoutState {
        case normal
        case compact
    }
    
    func applyLayout(state: LayoutState, keyboardHeight: CGFloat) {
        switch state {
        case .normal:
            backgroundHeightConstraint?.constant = 118
            logoTopConstraint?.constant = 135
            backgroundBottomConstraint?.constant = 0
            activateContentWrapperSafeArea()
        case .compact:
            backgroundHeightConstraint?.constant = 88
            logoTopConstraint?.constant = 30
            backgroundBottomConstraint?.constant = -keyboardHeight
            activateContentWrapperBackground()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
