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

enum ScheduleLoadState: Equatable {
    case loading
    case loaded
    case empty
    case error(String)
}

enum DataSourceMode: String, CaseIterable, Identifiable {
    case realAPI = "API"
    case stubEmpty = "Порожня відповідь"
    case stubHttpError = "Помилка сервера"
    case stubTransportError = "Немає інтернету"
    case stubDecodingError = "Помилка декодування"
    
    var id: String { rawValue }
}

@MainActor
final class ScheduleViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    @Published var loadState: ScheduleLoadState = .loading
    @Published var currentMode: DataSourceMode = .realAPI
    
    private var service: LessonServiceProtocol
    private let serviceFactory: ((DataSourceMode) -> LessonServiceProtocol)?
    private var latestUsdRate: Double?
    
    init(
        service: LessonServiceProtocol,
        serviceFactory: ((DataSourceMode) -> LessonServiceProtocol)? = nil
    ) {
        self.service = service
        self.serviceFactory = serviceFactory
    }
    
    func loadLessons() async {
        loadState = .loading
        do {
            let fetched = try await service.fetchLessons()
            self.lessons = fetched.sorted { $0.startTime < $1.startTime }
            if let rate = self.lessons.first?.usdRate {
                self.latestUsdRate = rate
            }
            self.loadState = self.lessons.isEmpty ? .empty : .loaded
        } catch {
            self.lessons = []
            self.loadState = .error(error.localizedDescription)
        }
    }
    
    func switchDataSource(to mode: DataSourceMode) async {
        currentMode = mode
        if let factory = serviceFactory {
            self.service = factory(mode)
        }
        await loadLessons()
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
            note: note?.isEmpty == true ? nil : note,
            usdRate: latestUsdRate
        )
        service.addLesson(newLesson)
        lessons.append(newLesson)
        lessons.sort { $0.startTime < $1.startTime }
        loadState = lessons.isEmpty ? .empty : .loaded
    }
    
    func updateLesson(_ updatedLesson: Lesson) {
        service.updateLesson(updatedLesson)
        if let index = lessons.firstIndex(where: { $0.id == updatedLesson.id }) {
            lessons[index] = updatedLesson
            lessons.sort { $0.startTime < $1.startTime }
        }
    }
    
    func togglePaymentStatus(lessonId: UUID) {
        guard var current = lesson(by: lessonId) else { return }
        current.currentStatus = (current.currentStatus == .pending) ? .paid : .pending
        updateLesson(current)
    }
    
    func deleteLesson(id: UUID) {
        service.deleteLesson(id: id)
        lessons.removeAll { $0.id == id }
        if lessons.isEmpty {
            loadState = .empty
        }
    }
    
    var unpaidCount: Int {
        lessons.filter { $0.currentStatus == .pending }.count
    }
}
