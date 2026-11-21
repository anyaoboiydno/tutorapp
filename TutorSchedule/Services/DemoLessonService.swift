import Foundation

final class DemoLessonService: LessonServiceProtocol {
    private var lessons: [Lesson] = [
        LessonFactory.createLesson(
            student: "Демонстраційний учень",
            subject: "SwiftUI Architecture",
            price: 600,
            isPaid: false,
            homework: "Реалізувати Router та 3 екрани",
            note: "Демонстраційний запис"
        )
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
    
    func deleteLesson(id: UUID) {
        lessons.removeAll { $0.id == id }
    }
}
