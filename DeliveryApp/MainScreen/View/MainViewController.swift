import UIKit

protocol MainViewProtocol: AnyObject {
    func updateContent(banners: [UIImage], categories: [String], menuItems: [MenuItemModel])
}

final class MainViewController: UIViewController {
    private let mainView = MainView()
    private let bannerDataSource = BannerCellDataSource()
    private let categoryDataSource = CategoryCellDataSource()
    private let categoryDelegate = CategoryCollectionDelegate()
    private let menuDataSource = MenuCellDataSource()
    private let presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol = MainPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup View
private extension MainViewController {
    func setupView() {
        presenter.viewDidLoad(view: self)
        setupDelegates()
        setupDataSource()
        setupTitle()
    }
    
    func setupDataSource() {
        mainView.setupDataSource(banner: bannerDataSource,
                                 category: categoryDataSource,
                                 menu: menuDataSource)
    }
    
    func setupDelegates() {
        mainView.setupDelegate(category: categoryDelegate)
    }
}

extension MainViewController: MainViewProtocol {
    func displayData() {
        mainView.reloadBannerData()
        mainView.reloadCategoryData()
        mainView.reloadMenuData()
    }
}

extension MainViewController {
    func updateContent(banners: [UIImage], categories: [String], menuItems: [MenuItemModel]) {
        bannerDataSource.updateBanners(banners)
        categoryDataSource.updateCategories(categories, selectedIndex: 0)
        categoryDelegate.update(categoriesCount: categories.count, selectedIndex: 0)
        menuDataSource.updateMenuItems(menuItems)
        displayData()
    }
    
    func setupTitle(with text: String = "Москва") {
        mainView.setupTitle(with: text)
    }
}

