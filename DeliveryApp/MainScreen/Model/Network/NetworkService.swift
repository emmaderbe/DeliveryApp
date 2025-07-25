import Foundation

// MARK: - Protocol
protocol NetworkServiceProtocol {
    func fetchCategories(completion: @escaping (Result<MealCategoryResponse, Error>) -> Void)
    func fetchMeals(for category: String, completion: @escaping (Result<MealListResponse, Error>) -> Void)
    func fetchRandomFoodImageURL(completion: @escaping (Result<URL, Error>) -> Void)
}

// MARK: - Errors
enum NetworkError: Error {
    case invalidURL
    case clientError
    case serverError
    case noResults
    case unknown
}

// MARK: - NetworkServiceProtocol functions
final class NetworkService: NetworkServiceProtocol {
    private let urlSession = URLSession.shared
    
    func fetchCategories(completion: @escaping (Result<MealCategoryResponse, Error>) -> Void) {
        guard let request = makeCategoriesRequest() else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }

    func fetchMeals(for category: String, completion: @escaping (Result<MealListResponse, Error>) -> Void) {
        guard let request = makeMealsRequest(for: category) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func fetchRandomFoodImageURL(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let request = makeRandomFoodImageRequest() else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let urlString = json["image"] as? String,
                let imageURL = URL(string: urlString)
            else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noResults))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(imageURL))
            }
        }.resume()
    }
}

// MARK: - Request builder
private extension NetworkService {
    func makeCategoriesRequest() -> URLRequest? {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
            return nil
        }
        return URLRequest(url: url)
    }

    func makeMealsRequest(for category: String) -> URLRequest? {
        let encoded = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(encoded)"
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    func makeRandomFoodImageRequest() -> URLRequest? {
        guard let url = URL(string: "https://foodish-api.com/api/") else {
            return nil
        }
        return URLRequest(url: url)
    }
}

private extension NetworkService {
    func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknown))
            return
        }

        switch httpResponse.statusCode {
        case 200...299:
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.unknown))
                }
            }
        case 400...499:
            completion(.failure(NetworkError.clientError))
        case 500...599:
            completion(.failure(NetworkError.serverError))
        default:
            completion(.failure(NetworkError.unknown))
        }
    }
}
