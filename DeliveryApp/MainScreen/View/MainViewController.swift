import UIKit

protocol MainViewProtocol: AnyObject {
    func updateContent(banners: [UIImage], categories: [String], menuItems: [MenuItemModel])
    func updateItem(at index: Int, with image: UIImage)
    func scrollToMenuItem(at index: Int)
}

final class MainViewController: UIViewController {
    // MARK: - UI
    private let mainView = MainView()
    private let bannerDataSource = BannerCellDataSource()
    private let categoryDataSource = CategoryCellDataSource()
    private let categoryDelegate = CategoryCollectionDelegate()
    private let menuDataSource = MenuCellDataSource()
    
    private var isProgrammaticScroll = false
    
    // MARK: - Dependencies
    private let presenter: MainPresenterProtocol
    
    // MARK: - Init
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
        setupScroll()
    }
    
    func setupDataSource() {
        mainView.setupDataSource(banner: bannerDataSource,
                                 category: categoryDataSource,
                                 menu: menuDataSource)
    }
    
    func setupDelegates() {
        categoryDelegate.delegate = self
        mainView.setupDelegate(category: categoryDelegate)
    }
    
    func setupTitle(with text: String = "Москва") {
        mainView.setupTitle(with: text)
    }
    
    func displayData() {
        mainView.reloadBannerData()
        mainView.reloadCategoryData()
        mainView.reloadMenuData()
    }
}

// MARK: - Scroll Tracking
extension MainViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isProgrammaticScroll else { return }
        
        let triggerOffset = mainView.bannerFrameMaxY + 24
        let shouldPin = scrollView.contentOffset.y >= triggerOffset
        mainView.pinCategoryToTop(shouldPin)
    }
    
    func setupScroll() {
        mainView.setMenuScrollDelegate(self)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isProgrammaticScroll = false
    }
}

// MARK: - MainViewProtocol
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
    
    func scrollToMenuItem(at index: Int) {
        isProgrammaticScroll = true
        mainView.scrollMenuToItem(at: index)
    }
}

// MARK: - Category Selection
extension MainViewController: CategoryCollectionDelegateProtocol {
    func didSelectCategory(at index: Int) {
        presenter.didSelectCategory(at: index)
    }
}

