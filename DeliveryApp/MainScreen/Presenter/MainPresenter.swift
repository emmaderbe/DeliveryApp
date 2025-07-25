import Foundation
import UIKit

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad(view: MainViewProtocol)
}


final class MainPresenter: MainPresenterProtocol  {
    weak var view: MainViewProtocol?
    
    private var categories: [String] = []
    private var menuItems: [MenuItemModel] = []
    
    private let networkService: NetworkServiceProtocol
    private let mapper: MenuMapperProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         mapper: MenuMapperProtocol = MenuMapper()) {
        self.networkService = networkService
        self.mapper = mapper
    }
}

extension MainPresenter {
    func viewDidLoad(view: MainViewProtocol) {
        self.view = view
        loadCategories()
    }
    
    private func loadCategories() {
        networkService.fetchCategories { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleCategories(response.categories)
            case .failure(let error):
                print("❌ Failed to fetch categories:", error)
            }
        }
    }
    
    private func handleCategories(_ categories: [MealCategory]) {
        let top = Array(categories)
        self.categories = top.map { $0.name }
        loadMeals(for: top.map { $0.name })
    }
    
    private func loadMeals(for categoryNames: [String]) {
        let group = DispatchGroup()
        var allMeals: [MenuItemModel] = []
        
        for name in categoryNames {
            group.enter()
            networkService.fetchMeals(for: name) { [weak self] result in
                defer { group.leave() }
                
                switch result {
                case .success(let response):
                    let topMeals = Array(response.meals.prefix(5))
                    let models = self?.mapper.map(topMeals) ?? []
                    allMeals.append(contentsOf: models)
                case .failure(let error):
                    print("⚠️ Failed to load meals for \(name):", error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.menuItems = allMeals
            self?.view?.updateContent(
                banners: [],
                categories: self?.categories ?? [],
                menuItems: allMeals
            )
        }
    }
}


