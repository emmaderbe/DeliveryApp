import UIKit

final class AuthTextField: UITextField {
    // MARK: - Private properties
    private var isPasswordField: Bool = false
    private var eyeButton: UIButton?
    
    // MARK: - Initialization
    init(placeholder: String, icon: AuthIcon, isSecure: Bool = false) {
        super.init(frame: .zero)
        
        // text
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        self.isPasswordField = isSecure
        
        // ui
        setupUI()
        setupPlaceholder(with: placeholder)
        
        //constraints
        setupConstraints()
        
        // icon
        self.leftView = makeLeftIcon(icon)
        
        // icon of right eye
        if isPasswordField {
            addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            setupEyeButton()
        }
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup textField UI
private extension AuthTextField {
    func setupUI() {
        self.borderStyle = .roundedRect
        self.leftViewMode = .always
        self.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.layer.borderColor = UIColor(named: "AccentGrey")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    func setupPlaceholder(with placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(named: "AccentGrey") ?? .lightGray,
                .font: UIFont.systemFont(ofSize: 13, weight: .regular)
            ]
        )
    }
    
    func setupConstraints() {
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Setup left icon
enum AuthIcon: String {
    case person = "person"
    case lock = "lock"
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

private extension AuthTextField {
    func makeLeftIcon(_ icon: AuthIcon) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 18))
        let imageView = UIImageView(image: icon.image)
        imageView.tintColor = UIColor(named: "AccentGrey")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 16, y: 0, width: 18, height: 18)
        container.addSubview(imageView)
        return container
    }
}

// MARK: - Setup right icon
private extension AuthTextField {
    func setupEyeButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "eyeClose"), for: .normal)
        button.tintColor = UIColor(named: "AccentGrey")
        button.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 18))
        container.addSubview(button)
        
        self.rightView = container
        self.rightViewMode = .always
        self.eyeButton = button
        button.isHidden = true
    }

    
    @objc func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eyeClose" : "eyeOpen"
        eyeButton?.setImage(UIImage(named: imageName), for: .normal)

        let currentText = text
        text = ""
        insertText(currentText ?? "")
    }
    
    @objc func textDidChange() {
        eyeButton?.isHidden = (text?.isEmpty ?? true)
    }
}
