import Foundation

protocol LessonServiceProtocol {
    func fetchLessons() async throws -> [Lesson]
    func addLesson(_ lesson: Lesson)
    func updateLesson(_ lesson: Lesson)
    func deleteLesson(id: UUID)
}
