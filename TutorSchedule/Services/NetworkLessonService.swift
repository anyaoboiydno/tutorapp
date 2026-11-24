import Foundation

final class NetworkLessonService: LessonServiceProtocol {
    private let apiClient: APIClientProtocol
    private var cachedLessons: [Lesson] = []
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchLessons() async throws -> [Lesson] {
        let queryItems = [
            URLQueryItem(name: "valcode", value: "USD"),
            URLQueryItem(name: "json", value: nil)
        ]
        
        let rates: [NbuExchangeRateDTO] = try await apiClient.get(
            endpoint: "/NBUStatService/v1/statdirectory/exchange",
            queryItems: queryItems
        )
        
        guard let usdRate = rates.first?.rate else {
            return []
        }
        
        let presets: [(
            student: String,
            subject: String,
            price: Int,
            dayOffset: Int,
            hour: Int,
            minute: Int,
            isPaid: Bool,
            homework: String,
            note: String?
        )] = [
            ("Нікіта", "English (НМТ)", 500, 0, 14, 0, false, "Unit 4, вправи 1–5; вивчити 15 фразових дієслів", "Акцент на граматику Conditionals"),
            ("Аліса", "Математика (Алгебра)", 450, 0, 17, 30, true, "Розв'язати 10 задач на квадратні нерівності", "Підготовка до контрольної роботи"),
            ("Діма", "English (ЄВІ)", 600, 1, 11, 0, false, "Пройти тест Reading №3", nil),
            ("Ксюша", "General English B1", 550, 1, 16, 0, true, "Подивитися відео TED і виписати 10 виразів", "Рівень B1, більше розмовної практики"),
            ("Олена", "Математика (НМТ)", 500, 2, 15, 0, false, "Повторити тригонометричні формули", "Перенести на 15 хв раніше за потреби")
        ]
        
        let calendar = Calendar.current
        let mapped = presets.map { preset -> Lesson in
            let baseDay = calendar.date(byAdding: .day, value: preset.dayOffset, to: Date()) ?? Date()
            let scheduledTime = calendar.date(
                bySettingHour: preset.hour,
                minute: preset.minute,
                second: 0,
                of: baseDay
            ) ?? baseDay
            
            return LessonFactory.createLesson(
                student: preset.student,
                subject: preset.subject,
                price: preset.price,
                startTime: scheduledTime,
                isPaid: preset.isPaid,
                homework: preset.homework,
                note: preset.note,
                usdRate: usdRate
            )
        }
        
        self.cachedLessons = mapped
        return mapped
    }
    
    func addLesson(_ lesson: Lesson) {
        cachedLessons.append(lesson)
    }
    
    func updateLesson(_ lesson: Lesson) {
        if let index = cachedLessons.firstIndex(where: { $0.id == lesson.id }) {
            cachedLessons[index] = lesson
        }
    }
    
    func deleteLesson(id: UUID) {
        cachedLessons.removeAll { $0.id == id }
    }
}
