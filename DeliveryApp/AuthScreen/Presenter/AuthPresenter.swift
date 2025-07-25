import Foundation

// MARK: - AuthPresenterProtocol
protocol AuthPresenterProtocol: AnyObject {
    func viewDidLoad(view: AuthViewProtocol)
    func didTapLogin()
    func didUpdateLoginFields()
}

final class AuthPresenter: AuthPresenterProtocol {
    // MARK: - Private properties
    private weak var view: AuthViewProtocol?
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AuthPresenterProtocol functions
extension AuthPresenter {
    func viewDidLoad(view: AuthViewProtocol) {
        self.view = view
        validateForm()
    }
    
    func didTapLogin() {
        guard let login = view?.getLoginText(),
              let password = view?.getPasswordText() else { return }
        
        authService.login(login: login, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.showSuccess(message: "Вход выполнен успешно")
                    self?.view?.navigateToMain()
                case .failure(let error):
                    switch error {
                    case .invalidCredentials:
                        self?.view?.showError(message: "Неверный логин или пароль")
                    }
                }
            }
        }
    }
    
    
    func didUpdateLoginFields() {
        validateForm()
    }
}

// MARK: - Private Logic
private extension AuthPresenter {
    // Проверяет, заполнены ли поля логина и пароля, и включает/отключает кнопку
    func validateForm() {
        guard let view = view else { return }
        let isValid = !view.getLoginText().isEmpty && !view.getPasswordText().isEmpty
        view.setLoginButtonEnabled(isValid)
    }
}
