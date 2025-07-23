import UIKit

protocol KeyboardServiceProtocol: AnyObject {
    var onKeyboardChange: ((_ height: CGFloat, _ duration: TimeInterval, _ curve: UIView.AnimationCurve) -> Void)? { get set }
    func enableKeyboardDismiss(on view: UIView)
}


final class KeyboardService: KeyboardServiceProtocol {
    var onKeyboardChange: ((_ height: CGFloat, _ duration: TimeInterval, _ curve: UIView.AnimationCurve) -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardChange),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension KeyboardService {
    func enableKeyboardDismiss(on view: UIView) {
           let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
           tapGesture.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture)
       }
}

private extension KeyboardService {
    @objc func handleKeyboardChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        let keyboardHeight = max(0, UIScreen.main.bounds.height - endFrame.origin.y)
        let curve = UIView.AnimationCurve(rawValue: Int(curveRaw)) ?? .easeInOut

        onKeyboardChange?(keyboardHeight, duration, curve)
    }
}
