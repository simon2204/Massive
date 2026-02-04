import Fetch
import Foundation

/// Real-time aggregate bar data from WebSocket stream.
///
/// Used for both per-second (`A`) and per-minute (`AM`) aggregates.
public struct StreamAggregate: Sendable, Decodable {
    /// The event type (`A` for second, `AM` for minute).
    public let eventType: String

    /// The ticker symbol.
    public let symbol: String

    /// The tick volume.
    public let volume: Int

    /// Today's accumulated volume.
    public let accumulatedVolume: Int

    /// Today's official opening price.
    public let officialOpen: Double

    /// The tick's volume weighted average price.
    public let vwap: Double

    /// The opening price for this aggregate window.
    public let open: Double

    /// The closing price for this aggregate window.
    public let close: Double

    /// The highest price for this aggregate window.
    public let high: Double

    /// The lowest price for this aggregate window.
    public let low: Double

    /// Today's volume weighted average price.
    public let dailyVwap: Double

    /// The average trade size for this aggregate window.
    public let averageTradeSize: Int

    /// The starting timestamp of this aggregate window.
    public let startTimestamp: Timestamp

    /// The ending timestamp of this aggregate window.
    public let endTimestamp: Timestamp

    /// Whether this aggregate is for an OTC ticker. Omitted if false.
    public let isOTC: Bool?

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "sym"
        case volume = "v"
        case accumulatedVolume = "av"
        case officialOpen = "op"
        case vwap = "vw"
        case open = "o"
        case close = "c"
        case high = "h"
        case low = "l"
        case dailyVwap = "a"
        case averageTradeSize = "z"
        case startTimestamp = "s"
        case endTimestamp = "e"
        case isOTC = "otc"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decode(String.self, forKey: .eventType)
        symbol = try container.decode(String.self, forKey: .symbol)
        volume = try container.decode(Int.self, forKey: .volume)
        accumulatedVolume = try container.decode(Int.self, forKey: .accumulatedVolume)
        officialOpen = try container.decode(Double.self, forKey: .officialOpen)
        vwap = try container.decode(Double.self, forKey: .vwap)
        open = try container.decode(Double.self, forKey: .open)
        close = try container.decode(Double.self, forKey: .close)
        high = try container.decode(Double.self, forKey: .high)
        low = try container.decode(Double.self, forKey: .low)
        dailyVwap = try container.decode(Double.self, forKey: .dailyVwap)
        averageTradeSize = try container.decode(Int.self, forKey: .averageTradeSize)
        let startMs = try container.decode(Int64.self, forKey: .startTimestamp)
        startTimestamp = Timestamp(millisecondsSinceEpoch: startMs)
        let endMs = try container.decode(Int64.self, forKey: .endTimestamp)
        endTimestamp = Timestamp(millisecondsSinceEpoch: endMs)
        isOTC = try container.decodeIfPresent(Bool.self, forKey: .isOTC)
    }
}
