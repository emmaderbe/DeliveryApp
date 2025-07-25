import UIKit

final class MainView: UIView {
    // MARK: - Private properties
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
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            bannerCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            bannerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.138),

            categoryCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 24),
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

// MARK: - Layouts
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

extension MainView {
    func setupTitle(with text: String) {
        titleLabel.text = text
    }
}

extension MainView {
    func setupDataSource(banner: BannerCellDataSource, category: CategoryCellDataSource, menu: MenuCellDataSource) {
        self.bannerCollectionView.dataSource = banner
        self.categoryCollectionView.dataSource = category
        self.menuCollectionView.dataSource = menu
    }
    
    func setupDelegate(category: CategoryCollectionDelegate) {
        self.categoryCollectionView.delegate = category
    }
}

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
}
