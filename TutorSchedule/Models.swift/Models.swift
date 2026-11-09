import Foundation

protocol Schedulable {
    var id: UUID { get }
    var startTime: Date { get }
    func summary() -> String
}

enum PaymentStatus: String {
    case paid = "Оплачено"
    case pending = "Очікує оплати"
}

struct Lesson: Schedulable {
    let id: UUID
    let student: String
    var startTime: Date
    var subject: String
    let price: Int
    var currentStatus: PaymentStatus
    var homework: String?
    var note: String?
    
    func summary() -> String {
        return "Урок: \(subject) з учнем \(student) [\(currentStatus.rawValue)]"
    }
}

class ScheduleManager {
    var lessons: [Lesson] = []
    
    func addLesson(_ lesson: Lesson) {
        lessons.append(lesson)
        print("Урок успішно додано для: \(lesson.student)")
    }
    
    func getEnglishLessons() -> [Lesson] {
        return lessons.filter { $0.subject == "English" }
    }
    
    func getUnpaidLessons() -> [Lesson] {
        return lessons.filter { $0.currentStatus == .pending }
    }
    
    func markAsPaid(lessonId: UUID) {
        if let index = lessons.firstIndex(where: { $0.id == lessonId }) {
            lessons[index].currentStatus = .paid
            print("Оплачено урок учня \(lessons[index].student)")
        }
    }
}

func runLab1Demo() {
    
    let manager = ScheduleManager()
    
    var lesson1 = Lesson(
        id: UUID(),
        student: "Nikita",
        startTime: Date(),
        subject: "English",
        price: 500,
        currentStatus: .pending,
        homework: "Вправи 3-5",
        note: nil
    )
    
    var lesson2 = Lesson(
        id: UUID(),
        student: "Аліса",
        startTime: Date().addingTimeInterval(3600),
        subject: "English",
        price: 450,
        currentStatus: .paid,
        homework: nil,
        note: "Підготовка до НМТ"
    )

    manager.addLesson(lesson1)
    manager.addLesson(lesson2)
    
    let unpaid = manager.getUnpaidLessons()
    print("Неоплачених уроків у списку: \(unpaid.count)")
    
    manager.markAsPaid(lessonId: lesson1.id)
    
}
