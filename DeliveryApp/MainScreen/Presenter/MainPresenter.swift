import UIKit

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad(view: MainViewProtocol)
}

final class MainPresenter: MainPresenterProtocol  {
    // MARK: - Private properties
    private weak var view: MainViewProtocol?
    private var categories: [String] = []
    private var menuItems: [MenuItemModel] = []
    private var banners: [UIImage] = []
    
    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    private let mapper: MenuMapperProtocol
    private let imageLoader: ImageLoaderProtocol
    private let urlBuilder: ImageURLBuilderProtocol
    
    // MARK: - Init
    init(networkService: NetworkServiceProtocol = NetworkService(),
         mapper: MenuMapperProtocol = MenuMapper(),
         imageLoader: ImageLoaderProtocol = ImageLoader(),
         urlBuilder: ImageURLBuilderProtocol = ImageURLBuilder()) {
        self.networkService = networkService
        self.mapper = mapper
        self.imageLoader = imageLoader
        self.urlBuilder = urlBuilder
    }
}

// MARK: - MainPresenterProtocol functions
extension MainPresenter {
    func viewDidLoad(view: MainViewProtocol) {
        self.view = view
        fetchAllData()
    }
}

// MARK: - Fetch all data and update UI
private extension MainPresenter {
    func fetchAllData() {
        loadCategories()
        loadBanners()
    }
    
    func updateContent() {
        view?.updateContent(
            banners: banners,
            categories: categories,
            menuItems: menuItems
        )
    }
}

// MARK: - Category Loading
private extension MainPresenter {
    // Загружает список категорий из API и начинает подготовку к загрузке блюд для категорий
    func loadCategories() {
        networkService.fetchCategories { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleCategories(response.categories)
            case .failure(let error):
                print("Failed to fetch categories:", error)
            }
        }
    }
    
    // Обрабатывает полученные категории: сохраняет названия и запускает загрузку блюд
    func handleCategories(_ categories: [MealCategory]) {
        let categories = Array(categories)
        self.categories = categories.map { $0.name }
        loadMeals(for: categories.map { $0.name })
    }
}

// MARK: - Meal Loading
private extension MainPresenter {
    // Загружает блюда по списку категорий, после вызывает метод обновления UI и запуска загрузки изображений
    func loadMeals(for categoryNames: [String]) {
        let group = DispatchGroup()
        var loadedMeals: [MenuItemModel] = []
        var imageURL: [(index: Int, url: URL)] = []
        var currentIndex = 0
        
        for name in categoryNames {
            group.enter()
            networkService.fetchMeals(for: name) { [weak self] result in
                defer { group.leave() }
                
                switch result {
                case .success(let response):
                    // оставляем только 5 первых блюд
                    let meals = Array(response.meals.prefix(5))
                    let models = self?.mapper.map(meals) ?? []
                    loadedMeals.append(contentsOf: models)
                    
                    // сохраняем URL изображений вместе с индексом модели
                    for (number, meal) in meals.enumerated() {
                        if let url = self?.urlBuilder.url(from: meal.imageURL) {
                            imageURL.append((index: currentIndex + number, url: url))
                        }
                    }
                    currentIndex += models.count
                    
                case .failure(let error):
                    print("Failed to load meals for \(name):", error)
                }
            }
        }
        // после загрузки всех категорий, обновляем UI и подгружаем картинки
        group.notify(queue: .main) { [weak self] in
            self?.handleMealsReady(loadedMeals, imageURL)
        }
    }
    func handleMealsReady(_ meals: [MenuItemModel], _ url: [(index: Int, url: URL)]) {
        self.menuItems = meals
        updateContent()
        
        for (index, url) in url {
            loadImage(at: index, from: url)
        }
    }
    
    // Загружает изображение по URL, вызывая потом обновление конкретной ячейки на экране
    func loadImage(at index: Int, from url: URL) {
        imageLoader.loadImage(from: url) { [weak self] data in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  index < self.menuItems.count else { return }
            
            self.menuItems[index].image = image
            self.view?.updateItem(at: index, with: image)
        }
    }
}

// MARK: - Banner Loading
private extension MainPresenter {
    // Загружает указанное количество баннеров из открытого API
    func loadBanners(count: Int = 5) {
        let group = DispatchGroup()
        var images: [UIImage] = []

        for _ in 0..<count {
            group.enter()
            networkService.fetchRandomFoodImageURL { [weak self] result in
                switch result {
                case .success(let imageURL):
                    self?.imageLoader.loadImage(from: imageURL) { data in
                        if let data = data, let image = UIImage(data: data) {
                            images.append(image)
                        }
                        group.leave()
                    }

                case .failure(let error):
                    print("Failed to fetch banner url:", error)
                    group.leave()
                }
            }
        }
        // когда все баннеры загружены — сохраняем и обновляем view
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.banners = images
            self.updateContent()
        }
    }
}



