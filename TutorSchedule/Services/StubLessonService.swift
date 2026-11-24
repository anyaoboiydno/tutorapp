import Foundation

enum StubScenario {
    case emptyResponse
    case httpServerError
    case transportOfflineError
    case decodingFormatError
}

final class StubLessonService: LessonServiceProtocol {
    private let scenario: StubScenario
    
    init(scenario: StubScenario) {
        self.scenario = scenario
    }
    
    func fetchLessons() async throws -> [Lesson] {
        // Невелика затримка, щоб було видно індикатор завантаження ProgressView
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch scenario {
        case .emptyResponse:
            return []
        case .httpServerError:
            throw NetworkError.httpError(statusCode: 500)
        case .transportOfflineError:
            throw NetworkError.transportError(URLError(.notConnectedToInternet))
        case .decodingFormatError:
            throw NetworkError.decodingError(
                DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid JSON schema"))
            )
        }
    }
    
    func addLesson(_ lesson: Lesson) {}
    func updateLesson(_ lesson: Lesson) {}
    func deleteLesson(id: UUID) {}
}
