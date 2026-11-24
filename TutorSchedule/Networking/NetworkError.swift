import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case transportError(Error)
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Некоректна адреса сервера."
            case .invalidResponse:
                return "Отримано некоректну відповідь від сервера."
            case .transportError:
                return "Помилка з'єднання з мережею."
            case .httpError:
                return "Помилка сервера. Спробуйте пізніше."
            case .decodingError:
                return "Помилка обробки даних."
            }
        }
}
