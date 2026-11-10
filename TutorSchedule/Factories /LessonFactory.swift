import Foundation

final class LessonFactory {
    static func createLesson(student: String, subject: String, price: Int, isPaid: Bool = false) -> Lesson {
        return Lesson(
            id: UUID(),
            student: student,
            startTime: Date(),
            subject: subject,
            price: price,
            currentStatus: isPaid ? .paid : .pending,
            homework: nil,
            note: nil
        )
    }
}
