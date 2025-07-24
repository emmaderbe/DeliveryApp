import UIKit

struct BackgroundViewFactory {
    static func createBackground() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "AccentBorder")?.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func createContentWrapper() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
