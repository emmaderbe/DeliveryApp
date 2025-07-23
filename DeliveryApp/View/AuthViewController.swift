import UIKit

final class AuthViewController: UIViewController {
    private let authView = AuthView()
    private let keyboardService: KeyboardServiceProtocol
    
    init(keyboardService: KeyboardServiceProtocol = KeyboardService()) {
        self.keyboardService = keyboardService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = authView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension AuthViewController {
    func setupView() {
        setupKeyboardHandling()
    }
}

private extension AuthViewController {
    func setupKeyboardHandling() {
        keyboardService.enableKeyboardDismiss(on: view)
        
        keyboardService.onKeyboardChange = { [weak self] height, duration, curve in
            self?.authView.adjustBackgroundForKeyboard(height: height, duration: duration, curve: curve)
        }
    }
}
