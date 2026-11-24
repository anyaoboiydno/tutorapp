import Foundation

final class NetworkLessonService: LessonServiceProtocol {
    private let apiClient: APIClientProtocol
    private var cachedLessons: [Lesson] = []
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchLessons() async throws -> [Lesson] {
        let queryItems = [URLQueryItem(name: "_limit", value: "6")]
        let dtos: [RemoteTodoDTO] = try await apiClient.get(endpoint: "/todos", queryItems: queryItems)
        let mapped = dtos.map { $0.toLesson() }
        self.cachedLessons = mapped
        return mapped
    }
    
    func addLesson(_ lesson: Lesson) {
        cachedLessons.append(lesson)
    }
    
    func updateLesson(_ lesson: Lesson) {
        if let index = cachedLessons.firstIndex(where: { $0.id == lesson.id }) {
            cachedLessons[index] = lesson
        }
    }
    
    func deleteLesson(id: UUID) {
        cachedLessons.removeAll { $0.id == id }
    }
}
