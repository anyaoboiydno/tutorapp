import Foundation

// Альтернативний сервіс для демонстрації заміни залежностей 
final class DemoLessonService: LessonServiceProtocol {
    private var lessons: [Lesson] = [
        LessonFactory.createLesson(student: "Демонстраційний учень", subject: "SwiftUI", price: 600, isPaid: false)
    ]

    func fetchLessons() -> [Lesson] {
        return lessons
    }

    func addLesson(_ lesson: Lesson) {
        lessons.append(lesson)
    }
    
    func updateLesson(_ lesson: Lesson) {
        if let index = lessons.firstIndex(where: { $0.id == lesson.id }) {
            lessons[index] = lesson
        }
    }
}
