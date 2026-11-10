import Foundation

final class MockLessonService: LessonServiceProtocol {
    private var lessons: [Lesson] = [
        LessonFactory.createLesson(student: "Нікіта", subject: "English", price: 500, isPaid: false),
        LessonFactory.createLesson(student: "Аліса", subject: "English", price: 450, isPaid: true)
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
