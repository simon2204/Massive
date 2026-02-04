import Foundation

/// Fair Market Value data from WebSocket stream.
///
/// Fair Market Value is a proprietary algorithm to generate a real-time,
/// accurate fair market value. Only available on Business plans.
public struct StreamFMV: Sendable, Decodable {
    /// The event type (`FMV`).
    public let eventType: String

    /// The ticker symbol.
    public let symbol: String

    /// The fair market value.
    public let fairMarketValue: Double

    /// The timestamp in nanoseconds.
    public let timestamp: Int64

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "sym"
        case fairMarketValue = "fmv"
        case timestamp = "t"
    }
}
