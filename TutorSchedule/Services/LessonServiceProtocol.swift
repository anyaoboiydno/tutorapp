import Foundation

// SOLID (DIP - Dependency Inversion): Протокол сервісу даних
protocol LessonServiceProtocol {
    func fetchLessons() -> [Lesson]
    func addLesson(_ lesson: Lesson)
    func updateLesson(_ lesson: Lesson)
}
