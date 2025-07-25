import UIKit

protocol MenuMapperProtocol: AnyObject {
    func map(_ model: [Meal]) -> [MenuItemModel] 
}

final class MenuMapper: MenuMapperProtocol {
    func map(_ model: [Meal]) -> [MenuItemModel] {
        model.map {
            MenuItemModel(
                image: nil,
                title: $0.title,
                description: "Ветчина,шампиньоны, увеличинная порция моцареллы, томатный соус",
                price: Int.random(in: 300...700)
            )
        }
    }
}
