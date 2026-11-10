import Foundation

struct Lesson: Identifiable {
    let id: UUID
    let student: String
    var startTime: Date
    var subject: String
    let price: Int
    var currentStatus: PaymentStatus
    var homework: String?
    var note: String?
}
