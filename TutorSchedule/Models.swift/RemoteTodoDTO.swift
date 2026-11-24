import Foundation

struct RemoteTodoDTO: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    func toLesson() -> Lesson {
        let students = ["Нікіта", "Аліса", "Діма", "Ксюша", "Олена", "Максим"]
        let subjects = [
            "English (НМТ)",
            "Математика (Алгебра)",
            "English (ЄВІ)",
            "Speaking Club",
            "Математика (НМТ)",
            "Business English"
        ]
        
        let studentName = students[(userId + id) % students.count]
        let subjectName = subjects[id % subjects.count]
        let lessonPrice = 500 + (id % 3) * 50
        
        // Розподіляємо отримані уроки між "Сьогодні" та "Завтра"
        let calendar = Calendar.current
        let dayOffset = id <= 3 ? 0 : 1
        let baseDay = calendar.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
        let hour = 10 + (id * 2) % 9
        let scheduledTime = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: baseDay) ?? baseDay
        
        return LessonFactory.createLesson(
            student: studentName,
            subject: subjectName,
            price: lessonPrice,
            startTime: scheduledTime,
            isPaid: completed,
            homework: "Завдання #\(id): \(title.capitalized)",
            note: "Отримано з REST API (запис ID: \(id), учень ID: \(userId))"
        )
    }
}
