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

    /// The tape (1 = NYSE, 2 = AMEX, 3 = Nasdaq).
    public let tape: Int

    /// The timestamp in Unix milliseconds.
    public let timestamp: Int64

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
}
