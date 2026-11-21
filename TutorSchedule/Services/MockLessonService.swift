import Foundation

final class MockLessonService: LessonServiceProtocol {
    private var lessons: [Lesson]
    
    init() {
        let calendar = Calendar.current
        let today = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: today) ?? today
        
        let today14 = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: today) ?? today
        let today17 = calendar.date(bySettingHour: 17, minute: 30, second: 0, of: today) ?? today
        let tomorrow11 = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: tomorrow) ?? tomorrow
        let tomorrow16 = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: tomorrow) ?? tomorrow
        let next15 = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: dayAfterTomorrow) ?? dayAfterTomorrow
        
        self.lessons = [
            LessonFactory.createLesson(
                student: "Нікіта",
                subject: "English (НМТ)",
                price: 500,
                startTime: today14,
                isPaid: false,
                homework: "Unit 4, вправи 1–5; вивчити 15 фразових дієслів",
                note: "Акцент на граматику Conditionals"
            ),
            LessonFactory.createLesson(
                student: "Аліса",
                subject: "Математика (Алгебра)",
                price: 450,
                startTime: today17,
                isPaid: true,
                homework: "Розв'язати 10 задач на квадратні нерівності",
                note: "Підготовка до контрольної роботи"
            ),
            LessonFactory.createLesson(
                student: "Діма",
                subject: "English (ЄВІ)",
                price: 600,
                startTime: tomorrow11,
                isPaid: false,
                homework: "Пройти тест Reading №3",
                note: nil
            ),
            LessonFactory.createLesson(
                student: "Ксюша",
                subject: "General English B1",
                price: 550,
                startTime: tomorrow16,
                isPaid: true,
                homework: "Подивитися відео TED і виписати 10 виразів",
                note: nil
            ),
            LessonFactory.createLesson(
                student: "Олена",
                subject: "Математика (НМТ)",
                price: 500,
                startTime: next15,
                isPaid: false,
                homework: "Повторити тригонометричні формули",
                note: "Перенести на 15 хв раніше за потреби"
            )
        ]
    }
    
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
