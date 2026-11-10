import Foundation
import Combine

final class ScheduleViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    
    private let service: LessonServiceProtocol
    
    init(service: LessonServiceProtocol) {
        self.service = service
        loadLessons()
    }
    
    func loadLessons() {
        self.lessons = service.fetchLessons()
    }
    
    func addLesson(student: String, subject: String, price: Int) {
        let newLesson = LessonFactory.createLesson(student: student, subject: subject, price: price)
        service.addLesson(newLesson)
        loadLessons()
    }
    
    func markAsPaid(lessonId: UUID) {
        if let index = lessons.firstIndex(where: { $0.id == lessonId }) {
            var updatedLesson = lessons[index]
            updatedLesson.currentStatus = .paid
            service.updateLesson(updatedLesson)
            loadLessons()
        }
    }
    
    var unpaidCount: Int {
        return lessons.filter { $0.currentStatus == .pending }.count
    }
}
