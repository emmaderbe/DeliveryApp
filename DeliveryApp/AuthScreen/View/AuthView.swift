import UIKit

// MARK: - AuthViewDelegate
protocol AuthViewDelegate: AnyObject {
    func didTapLoginButton()
    func didChangeText()
}

final class AuthView: UIView {
    // MARK: - Delegate
    weak var delegate: AuthViewDelegate?
    
    // MARK: - Private properties
    private let titleLabel = LabelFactory.createSubtitleLabel(with: "Авторизация")
    private let logoImageView = ImageFactory.makeLogoImageView()
    private let stackView = StackFactory.createVerticalStack(with: 8)
    private let loginTextField = AuthTextField(placeholder: "Логин",
                                               icon: .person)
    private let passwordTextField = AuthTextField(placeholder: "Пароль",
                                                  icon: .lock,
                                                  isSecure: true)
    private let backgroundView = BackgroundViewFactory.createBackground()
    private let contentWrapper = BackgroundViewFactory.createContentWrapper()
    private let loginButton = AuthButton(title: "Войти")
    
    // MARK: - Layout сonstraints
    private var logoTopConstraint: NSLayoutConstraint?
    private var backgroundHeightConstraint: NSLayoutConstraint?
    private var backgroundBottomConstraint: NSLayoutConstraint?
    private var contentWrapperToSafeAreaConstraint: NSLayoutConstraint?
    private var contentWrapperToBackgroundConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupActions()
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
        // Основные constraints, сохраняются в свойствах для изменения при появлении клавиатуры
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
        ])
    }
}

// MARK: - Edit UI after open/hide keyboard
extension AuthView {
    // Анимированно адаптирует layout экрана при открытии и закрытии клавиатуры
    func adjustBackgroundForKeyboard(height: CGFloat, duration: TimeInterval, curve: UIView.AnimationCurve) {
        let options = UIView.AnimationOptions(rawValue: UInt(curve.rawValue << 16))
        
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.applyLayout(state: height == 0 ? .normal : .compact,
                             keyboardHeight: height)
        }
    }
    
    // Активация нижнего констрейнта относительно safeArea
    func activateContentWrapperSafeArea() {
        contentWrapperToBackgroundConstraint?.isActive = false
        contentWrapperToSafeAreaConstraint?.isActive = true
    }
    
    // Активация нижнего констрейнта относительно backgroundView (для сдвига вверх)
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
            backgroundBottomConstraint?.constant = -keyboardHeight + 10
            activateContentWrapperBackground()
        }
        
        layoutIfNeeded()
    }
}

// MARK: - Actions (Button & TextFields)
private extension AuthView {
    func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @objc func loginTapped() {
        delegate?.didTapLoginButton()
    }
    
    @objc func textChanged() {
        delegate?.didChangeText()
    }
}


// MARK: - Public functions
extension AuthView {
    func setLoginButton(_ isEnabled: Bool) {
        guard loginButton.isEnabled != isEnabled else { return }
        loginButton.isEnabled = isEnabled
        loginButton.updateAppearance(isEnabled: isEnabled)
    }
    
    func getLoginText() -> String {
        loginTextField.text ?? ""
    }
    
    func getPasswordText() -> String {
        passwordTextField.text ?? ""
    }
}
