import Foundation
import UIKit

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad(view: MainViewProtocol)
}


final class MainPresenter: MainPresenterProtocol  {
    weak var view: MainViewProtocol?
    
    private var bannerImages: [UIImage] = []
    private var categories: [String] = []
    private var menuItems: [MenuItemModel] = []
}

extension MainPresenter {
    func viewDidLoad(view: MainViewProtocol) {
        self.view = view
        fetchData()
    }
}

private extension MainPresenter {
    func fetchData() {
        bannerImages = [
            UIImage(systemName: "flame.fill")!,
            UIImage(systemName: "leaf.fill")!,
            UIImage(systemName: "sun.max.fill")!
        ]
        
        // 2. Категории
        categories = ["Пицца", "Бургеры", "Суши", "Десерты"]
        
        // 3. Меню
        menuItems = [
            MenuItemModel(
                image: UIImage(systemName: "flame.fill"),
                title: "Острая пицца",
                subtitle: "Ветчина,шампиньоны, увеличинная порция моцареллы, томатный соус",
                price: 450
            ),
            MenuItemModel(
                image: UIImage(systemName: "leaf.fill"),
                title: "Веган бургер",
                subtitle: "С растительной котлетой и свежими овощами",
                price: 390
            ),
            MenuItemModel(
                image: UIImage(systemName: "sun.max.fill"),
                title: "Филадельфия",
                subtitle: "Классические роллы с лососем и сыром",
                price: 520
            ),
            MenuItemModel(
                image: UIImage(systemName: "moon.fill"),
                title: "Тирамису",
                subtitle: "Итальянский десерт с кофе и маскарпоне",
                price: 280
            )
        ]
        if let view = view as? MainViewController {
            view.updateContent(
                banners: bannerImages,
                categories: categories,
                menuItems: menuItems
            )
        }
    }
    
}
