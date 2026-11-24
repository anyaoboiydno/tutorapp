import Foundation

final class LessonFactory {
    static func createLesson(
        student: String,
        subject: String,
        price: Int,
        startTime: Date = Date(),
        isPaid: Bool = false,
        homework: String? = nil,
        note: String? = nil,
        usdRate: Double? = nil
    ) -> Lesson {
        return Lesson(
            id: UUID(),
            student: student,
            startTime: startTime,
            subject: subject,
            price: price,
            currentStatus: isPaid ? .paid : .pending,
            homework: homework,
            note: note,
            usdRate: usdRate
        )
    }
}
