import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }
}

// MARK: - Appearance
private extension MainTabBarController {
    func setupAppearance() {
        tabBar.tintColor = UIColor(named: "AccentPink")
        tabBar.unselectedItemTintColor = UIColor(named: "AccentGrey")
        tabBar.backgroundColor = .white
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .regular)
        ]

        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.masksToBounds = false
    }
}

// MARK: - Setup Tabs
private extension MainTabBarController {
    func setupTabs() {
        let menuVC = MainViewController()
        let contactsVC = MainViewController()
        let profileVC = MainViewController()
        let cartVC = MainViewController()
        
        menuVC.tabBarItem = TabBarItemFactory.make(.menu)
        contactsVC.tabBarItem = TabBarItemFactory.make(.contacts)
        profileVC.tabBarItem = TabBarItemFactory.make(.profile)
        cartVC.tabBarItem = TabBarItemFactory.make(.cart)
        
        viewControllers = [
            UINavigationController(rootViewController: menuVC),
            UINavigationController(rootViewController: contactsVC),
            UINavigationController(rootViewController: profileVC),
            UINavigationController(rootViewController: cartVC)
        ]
    }
}


enum TabBarItemType {
    case menu
    case contacts
    case profile
    case cart
}

struct TabBarItemFactory {
    static func make(_ type: TabBarItemType) -> UITabBarItem {
        switch type {
        case .menu:
            return UITabBarItem(title: "Меню",
                                image: UIImage(named: "menu"),
                                selectedImage: nil)
        case .contacts:
            return UITabBarItem(title: "Контакты",
                                image: UIImage(named: "location"),
                                selectedImage: nil)
        case .profile:
            return UITabBarItem(title: "Профиль",
                                image: UIImage(named: "person"),
                                selectedImage: nil)
        case .cart:
            return UITabBarItem(title: "Корзина",
                                image: UIImage(named: "cart"),
                                selectedImage: nil)
        }
    }
}
