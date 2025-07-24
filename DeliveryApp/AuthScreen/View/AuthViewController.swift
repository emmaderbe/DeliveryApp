import UIKit

// MARK: - AuthViewProtocol
protocol AuthViewProtocol: AnyObject {
    func setLoginButtonEnabled(_ isEnabled: Bool)
    func getLoginText() -> String
    func getPasswordText() -> String
    
    func showSuccess(message: String)
    func showError(message: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Dependencies
    private let authView = AuthView()
    private let presenter: AuthPresenterProtocol
    private let keyboardService: KeyboardServiceProtocol
    
    
    // MARK: - Init
    init(keyboardService: KeyboardServiceProtocol = KeyboardService(), presenter: AuthPresenterProtocol = AuthPresenter()) {
        self.keyboardService = keyboardService
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = authView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup View
private extension AuthViewController {
    func setupView() {
        presenter.viewDidLoad(view: self)
        setupKeyboardHandling()
        setupDelegates()
    }
    
    func setupDelegates() {
        authView.delegate = self
    }
}

// MARK: - Keyboard Handling
private extension AuthViewController {
    func setupKeyboardHandling() {
        // Прячем клавиатуру по тапу вне текстовых полей
        keyboardService.enableKeyboardDismiss(on: view)
        
        // Обновляем UI при появлении/скрытии клавиатуры
        keyboardService.onKeyboardChange = { [weak self] height, duration, curve in
            self?.authView.adjustBackgroundForKeyboard(height: height, duration: duration, curve: curve)
        }
    }
}

// MARK: - AuthViewProtocol
extension AuthViewController: AuthViewProtocol {
    func setLoginButtonEnabled(_ isEnabled: Bool) {
        authView.setLoginButton(isEnabled)
    }
    
    func getLoginText() -> String {
        authView.getLoginText()
    }
    
    func getPasswordText() -> String {
        authView.getPasswordText()
    }
    
    func showSuccess(message: String) {
        let snackbar = SnackbarView(text: message, style: .success)
        snackbar.show(in: view)
    }
    
    func showError(message: String) {
        let snackbar = SnackbarView(text: message, style: .error)
        snackbar.show(in: view)
    }
}


// MARK: - AuthViewDelegate
extension AuthViewController: AuthViewDelegate {
    func didTapLoginButton() {
        presenter.didTapLogin()
    }
    
    func didChangeText() {
        presenter.didUpdateLoginFields()
    }
}
