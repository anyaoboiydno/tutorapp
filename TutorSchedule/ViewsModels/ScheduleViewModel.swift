import Foundation
import Combine

struct LessonDaySection: Identifiable {
    let id: Date
    let title: String
    let lessons: [Lesson]
}

enum DayFilter: String, CaseIterable, Identifiable {
    case all = "Усі дні"
    case today = "Сьогодні"
    case tomorrow = "Завтра"
    
    var id: String { rawValue }
}

final class ScheduleViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    
    private let service: LessonServiceProtocol
    
    init(service: LessonServiceProtocol) {
        self.service = service
        loadLessons()
    }
    
    func loadLessons() {
        self.lessons = service.fetchLessons().sorted { $0.startTime < $1.startTime }
    }
    
    func lesson(by id: UUID) -> Lesson? {
        return lessons.first(where: { $0.id == id })
    }
    
    func groupedSections(dayFilter: DayFilter, onlyUnpaid: Bool) -> [LessonDaySection] {
        let calendar = Calendar.current
        
        let filtered = lessons.filter { lesson in
            let matchesUnpaid = !onlyUnpaid || lesson.currentStatus == .pending
            let matchesDay: Bool
            switch dayFilter {
            case .all:
                matchesDay = true
            case .today:
                matchesDay = calendar.isDateInToday(lesson.startTime)
            case .tomorrow:
                matchesDay = calendar.isDateInTomorrow(lesson.startTime)
            }
            return matchesUnpaid && matchesDay
        }
        
        let grouped = Dictionary(grouping: filtered) { lesson in
            calendar.startOfDay(for: lesson.startTime)
        }
        
        return grouped.keys.sorted().map { dayStart in
            let dayLessons = (grouped[dayStart] ?? []).sorted { $0.startTime < $1.startTime }
            return LessonDaySection(
                id: dayStart,
                title: dayStart.calendarSectionTitle(),
                lessons: dayLessons
            )
        }
    }
    
    func addLesson(
        student: String,
        subject: String,
        price: Int,
        startTime: Date,
        isPaid: Bool,
        homework: String?,
        note: String?
    ) {
        let newLesson = LessonFactory.createLesson(
            student: student,
            subject: subject,
            price: price,
            startTime: startTime,
            isPaid: isPaid,
            homework: homework?.isEmpty == true ? nil : homework,
            note: note?.isEmpty == true ? nil : note
        )
        service.addLesson(newLesson)
        loadLessons()
    }
    
    func updateLesson(_ updatedLesson: Lesson) {
        service.updateLesson(updatedLesson)
        loadLessons()
    }
    
    func togglePaymentStatus(lessonId: UUID) {
        guard var current = lesson(by: lessonId) else { return }
        current.currentStatus = (current.currentStatus == .pending) ? .paid : .pending
        service.updateLesson(current)
        loadLessons()
    }
    
    func deleteLesson(id: UUID) {
        service.deleteLesson(id: id)
        loadLessons()
    }
    
    var unpaidCount: Int {
        lessons.filter { $0.currentStatus == .pending }.count
    }
}
