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
}

// MARK: - AuthPresenterProtocol functions
extension AuthPresenter {
    func viewDidLoad(view: AuthViewProtocol) {
        self.view = view
        validateForm()
    }

    func didTapLogin() {
        print("Логин: \(view?.getLoginText() ?? "")")
        print("Пароль: \(view?.getPasswordText() ?? "")")
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
