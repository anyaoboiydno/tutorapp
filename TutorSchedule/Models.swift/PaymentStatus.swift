import Foundation

enum PaymentStatus: String, CaseIterable, Hashable {
    case pending = "Очікує оплати"
    case paid = "Оплачено"
}
