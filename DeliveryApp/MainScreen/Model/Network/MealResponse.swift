import Foundation

struct MealCategoryResponse: Decodable {
    let categories: [MealCategory]
}

struct MealCategory: Decodable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
    }
}

struct MealListResponse: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable {
    let id: String
    let title: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case title = "strMeal"
        case imageURL = "strMealThumb"
    }
}
