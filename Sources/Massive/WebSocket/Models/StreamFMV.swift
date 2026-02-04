import Fetch
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

    /// The timestamp.
    public let timestamp: Timestamp

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "sym"
        case fairMarketValue = "fmv"
        case timestamp = "t"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decode(String.self, forKey: .eventType)
        symbol = try container.decode(String.self, forKey: .symbol)
        fairMarketValue = try container.decode(Double.self, forKey: .fairMarketValue)
        // FMV timestamp is in nanoseconds
        let timestampNs = try container.decode(Int64.self, forKey: .timestamp)
        timestamp = Timestamp(nanosecondsSinceEpoch: timestampNs)
    }
}
