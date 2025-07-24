import UIKit

enum SnackbarStyle {
    case success
    case error
}

final class SnackbarView: UIView {
    // MARK: - Private properties
    private let label = LabelFactory.createOrdinaryLabel(with: "")
    private let icon = ImageFactory.createSnackBarImageView()
    private var hideTimer: Timer?
    
    // MARK: - Init
    init(text: String, style: SnackbarStyle) {
        super.init(frame: .zero)
        setupView(text: text,
                  style: style)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private setup UI
private extension SnackbarView {
    func setupView(text: String, style: SnackbarStyle) {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        
        [label, icon].forEach({addSubview($0)})
        configure(text: text,
                  style: style)
        setupConstraints()
        setupShadow()
    }
    
    func configure(text: String, style: SnackbarStyle) {
        label.text = text
        label.textColor = style == .success ? UIColor(named: "AccentGreen") : UIColor(named: "AccentPink")

        
        icon.image = style == .success ? UIImage(named: "checkCircle") : UIImage(named: "closeCircle")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
        ])
    }
    
    func setupShadow() {
           layer.shadowColor = UIColor.black.cgColor
           layer.shadowOpacity = 0.12
           layer.shadowOffset = CGSize(width: 0, height: 4)
           layer.shadowRadius = 4
       }
}

// MARK: - Public functions
extension SnackbarView {
    // Показывает Snackbar с анимацией и автоскрытием
    func show(in view: UIView, duration: TimeInterval = 3.0) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            heightAnchor.constraint(equalToConstant: 50)
        ])

        // Начальные параметры для анимации (выезд сверху)
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.transform = .identity
        }
        
        // Таймер на автоматическое скрытие
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.dismiss()
        }
    }
    
    // Анимация скрытия и удаление с экрана
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -50)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
