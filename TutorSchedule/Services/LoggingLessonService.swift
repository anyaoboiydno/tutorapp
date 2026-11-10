import Foundation

final class LoggingLessonService: LessonServiceProtocol {
    private let wrappedService: LessonServiceProtocol

    init(wrappedService: LessonServiceProtocol) {
        self.wrappedService = wrappedService
    }

    func fetchLessons() -> [Lesson] {
        print("[LOG] Запитуємо список уроків...")
        let lessons = wrappedService.fetchLessons()
        print("[LOG] Завантажено уроків: \(lessons.count)")
        return lessons
    }
    
    func addLesson(_ lesson: Lesson) {
        print("[LOG] Додавання нового уроку для: \(lesson.student)")
        wrappedService.addLesson(lesson)
    }
    
    func updateLesson(_ lesson: Lesson) {
        print("[LOG] Оновлення статусу уроку ID: \(lesson.id)")
        wrappedService.updateLesson(lesson)
    }
}
