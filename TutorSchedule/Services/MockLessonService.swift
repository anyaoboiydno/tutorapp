import Foundation

final class MockLessonService: LessonServiceProtocol {
    private var lessons: [Lesson]
    
    init() {
        let calendar = Calendar.current
        let today = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        
        let today14 = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: today) ?? today
        let tomorrow11 = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: tomorrow) ?? tomorrow
        
        self.lessons = [
            LessonFactory.createLesson(
                student: "Нікіта",
                subject: "English (НМТ)",
                price: 500,
                startTime: today14,
                isPaid: false,
                homework: "Unit 4, вправи 1–5",
                note: "Локальний тестовий запис"
            ),
            LessonFactory.createLesson(
                student: "Аліса",
                subject: "Математика (Алгебра)",
                price: 450,
                startTime: tomorrow11,
                isPaid: true,
                homework: "Квадратні нерівності",
                note: nil
            )
        ]
    }
    
    func fetchLessons() async throws -> [Lesson] {
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
