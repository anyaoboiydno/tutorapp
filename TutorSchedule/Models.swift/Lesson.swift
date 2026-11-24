import Foundation

struct Lesson: Identifiable, Hashable {
    let id: UUID
    var student: String
    var startTime: Date
    var subject: String
    var price: Int
    var currentStatus: PaymentStatus
    var homework: String?
    var note: String?
    var usdRate: Double? = nil
    
    var formattedPriceWithUSD: String {
        guard let rate = usdRate, rate > 0 else {
            return "\(price) грн"
        }
        let usd = Double(price) / rate
        return String(format: "%d грн (~%.1f $)", price, usd)
    }
}

extension Date {
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func calendarSectionTitle() -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "uk_UA")
        
        if calendar.isDateInToday(self) {
            formatter.dateFormat = "d MMMM"
            return "Сьогодні, \(formatter.string(from: self))"
        } else if calendar.isDateInTomorrow(self) {
            formatter.dateFormat = "d MMMM"
            return "Завтра, \(formatter.string(from: self))"
        } else {
            formatter.dateFormat = "EEEE, d MMMM"
            return formatter.string(from: self).capitalized
        }
    }
    
    func fullUkrainianDateTime() -> String {
        return "\(calendarSectionTitle()) о \(formattedTime())"
    }
}
