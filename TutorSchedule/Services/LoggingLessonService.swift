import Foundation

// Structural Pattern: Decorator з підтримкою async/await та логуванням помилок
final class LoggingLessonService: LessonServiceProtocol {
    private let wrappedService: LessonServiceProtocol

    init(wrappedService: LessonServiceProtocol) {
        self.wrappedService = wrappedService
    }

    func fetchLessons() async throws -> [Lesson] {
        print("[LOG] Виконується асинхронний запит на отримання уроків...")
        do {
            let lessons = try await wrappedService.fetchLessons()
            print("[LOG] Успішно отримано уроків: \(lessons.count)")
            return lessons
        } catch {
            print("[LOG ERROR] Помилка отримання уроків: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addLesson(_ lesson: Lesson) {
        print("[LOG] Додавання уроку для учня: \(lesson.student)")
        wrappedService.addLesson(lesson)
    }
    
    func updateLesson(_ lesson: Lesson) {
        print("[LOG] Оновлення уроку ID: \(lesson.id)")
        wrappedService.updateLesson(lesson)
    }
    
    func deleteLesson(id: UUID) {
        print("[LOG] Видалення уроку ID: \(id)")
        wrappedService.deleteLesson(id: id)
    }
}
