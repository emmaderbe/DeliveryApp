import UIKit

final class MainView: UIView {
    // MARK: - UI Components
    private let titleLabel = LabelFactory.createTitleLabel()
    private let bannerCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: MainView.makeBannerLayout())
        collection.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: MainView.makeCategoryLayout())
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let backgroundView = BackgroundViewFactory.createBackground()
    
    private let menuCollectionView : UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: MainView.makeMenuLayout())
        collection.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.identifier)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - Private properties
    private var categoryTopConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension MainView {
    func setupView() {
        backgroundColor = UIColor(named: "AccentBackground")
        [titleLabel, bannerCollectionView,
         categoryCollectionView,
         backgroundView].forEach { addSubview($0) }
        
        backgroundView.addSubview(menuCollectionView)
    }
    
    func setupConstraints() {
        categoryTopConstraint = categoryCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 24)
        
        guard let categoryTopConstraint else {return}
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            bannerCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            bannerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.138),
            
            categoryTopConstraint,
            categoryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.039),
            
            backgroundView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 24),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            menuCollectionView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            menuCollectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
        ])
    }
}

// MARK: - Layouts builder
private extension MainView {
    static func makeBannerLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 112)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    
    static func makeCategoryLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 88, height: 32)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    
    static func makeMenuLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 156)
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}

// MARK: - Public Setup
extension MainView {
    func setupTitle(with text: String) {
        titleLabel.text = text
    }
    
    func setupDataSource(banner: BannerCellDataSource, category: CategoryCellDataSource, menu: MenuCellDataSource) {
        self.bannerCollectionView.dataSource = banner
        self.categoryCollectionView.dataSource = category
        self.menuCollectionView.dataSource = menu
    }
    
    func setupDelegate(category: CategoryCollectionDelegate) {
        self.categoryCollectionView.delegate = category
    }
    
    func setMenuScrollDelegate(_ delegate: UICollectionViewDelegate) {
        menuCollectionView.delegate = delegate
    }
}

// MARK: - Reload Methods
extension MainView {
    func reloadBannerData() {
        self.bannerCollectionView.reloadData()
    }
    
    func reloadCategoryData() {
        self.categoryCollectionView.reloadData()
    }
    
    func reloadMenuData() {
        self.menuCollectionView.reloadData()
    }
    
    func reloadMenuItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.menuCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - Dynamic Layout
extension MainView {
    func scrollMenuToItem(at index: Int) {
        menuCollectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                        at: .top,
                                        animated: true)
    }
    
    func pinCategoryToTop(_ isPinned: Bool) {
        categoryTopConstraint?.isActive = false
        if isPinned {
            bannerCollectionView.isHidden = true
            categoryTopConstraint = categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        } else {
            bannerCollectionView.isHidden = false
            categoryTopConstraint = categoryCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 24)
        }
        categoryTopConstraint?.isActive = true
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    var bannerFrameMaxY: CGFloat {
        bannerCollectionView.frame.maxY
    }
}

