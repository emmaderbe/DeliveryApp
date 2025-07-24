import Foundation

protocol AuthServiceProtocol {
    func login(login: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
}

enum AuthError: Error {
    case invalidCredentials
}

final class AuthService: AuthServiceProtocol {
    func login(login: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if login == "admin" && password == "1234" {
                completion(.success(()))
            } else {
                completion(.failure(.invalidCredentials))
            }
        }
    }
}


