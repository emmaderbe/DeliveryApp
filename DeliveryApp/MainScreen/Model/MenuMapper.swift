import UIKit

protocol MenuMapperProtocol: AnyObject {
    func map(_ model: [Meal], category: String) -> [MenuItemModel]
}

final class MenuMapper: MenuMapperProtocol {
    func map(_ model: [Meal], category: String) -> [MenuItemModel] {
        model.map {
            MenuItemModel(
                image: nil,
                category: category,
                title: $0.title,
                description: "Ветчина,шампиньоны, увеличинная порция моцареллы, томатный соус",
                price: Int.random(in: 300...700)
            )
        }
    }
}

