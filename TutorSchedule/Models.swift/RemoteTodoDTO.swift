import Foundation

struct NbuExchangeRateDTO: Decodable {
    let txt: String
    let rate: Double
    let cc: String
    let exchangedate: String
}
