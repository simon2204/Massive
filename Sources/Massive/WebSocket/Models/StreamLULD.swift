import Fetch
import Foundation

/// Limit Up - Limit Down price band data from WebSocket stream.
public struct StreamLULD: Sendable, Decodable {
    /// The event type (`LULD`).
    public let eventType: String

    /// The ticker symbol.
    public let symbol: String

    /// The high price limit.
    public let highLimit: Double

    /// The low price limit.
    public let lowLimit: Double

    /// Indicator codes signaling price band events.
    public let indicators: [Int]?

    /// The tape indicating the primary listing exchange.
    public let tape: Tape

    /// The timestamp.
    public let timestamp: Timestamp

    /// The sequence number.
    public let sequenceNumber: Int64

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "T"
        case highLimit = "h"
        case lowLimit = "l"
        case indicators = "i"
        case tape = "z"
        case timestamp = "t"
        case sequenceNumber = "q"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decode(String.self, forKey: .eventType)
        symbol = try container.decode(String.self, forKey: .symbol)
        highLimit = try container.decode(Double.self, forKey: .highLimit)
        lowLimit = try container.decode(Double.self, forKey: .lowLimit)
        indicators = try container.decodeIfPresent([Int].self, forKey: .indicators)
        tape = try container.decode(Tape.self, forKey: .tape)
        let timestampMs = try container.decode(Int64.self, forKey: .timestamp)
        timestamp = Timestamp(millisecondsSinceEpoch: timestampMs)
        sequenceNumber = try container.decode(Int64.self, forKey: .sequenceNumber)
    }
}
