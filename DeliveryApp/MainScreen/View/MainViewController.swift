import UIKit

protocol MainViewProtocol: AnyObject {
    func updateContent(banners: [UIImage], categories: [String], menuItems: [MenuItemModel])
    func updateItem(at index: Int, with image: UIImage)
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

private extension MainViewController {
    func displayData() {
        mainView.reloadBannerData()
        mainView.reloadCategoryData()
        mainView.reloadMenuData()
    }
    
    func setupTitle(with text: String = "Москва") {
        mainView.setupTitle(with: text)
    }
}

extension MainViewController: MainViewProtocol {
    func updateItem(at index: Int, with image: UIImage) {
        menuDataSource.updateImage(at: index, with: image)
        mainView.reloadMenuItem(at: index)
    }
    
    func updateContent(banners: [UIImage], categories: [String], menuItems: [MenuItemModel]) {
        bannerDataSource.updateBanners(banners)
        categoryDataSource.updateCategories(categories, selectedIndex: 0)
        categoryDelegate.update(categoriesCount: categories.count, selectedIndex: 0)
        menuDataSource.updateMenuItems(menuItems)
        displayData()
    }
}

