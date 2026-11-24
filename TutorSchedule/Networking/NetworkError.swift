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
            return "Некоректна адреса сервера (URL)."
        case .invalidResponse:
            return "Отримано некоректну відповідь від сервера."
        case .transportError(let error):
            return "Помилка з'єднання з мережею: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "Помилка сервера (HTTP статус \(statusCode)). Спробуйте пізніше."
        case .decodingError:
            return "Помилка обробки даних: формат відповіді сервера не відповідає очікуваній моделі."
        }
    }
}
