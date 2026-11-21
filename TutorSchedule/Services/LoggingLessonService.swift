import Foundation

final class LoggingLessonService: LessonServiceProtocol {
    private let wrappedService: LessonServiceProtocol

    init(wrappedService: LessonServiceProtocol) {
        self.wrappedService = wrappedService
    }

    func fetchLessons() -> [Lesson] {
        print("[LOG] Завантаження списку уроків...")
        let lessons = wrappedService.fetchLessons()
        print("[LOG] Отримано уроків: \(lessons.count)")
        return lessons
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
