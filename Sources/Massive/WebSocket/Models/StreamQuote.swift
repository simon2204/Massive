import Fetch
import Foundation

/// Real-time NBBO quote data from WebSocket stream.
public struct StreamQuote: Sendable, Decodable {
    /// The event type (`Q`).
    public let eventType: String

    /// The ticker symbol.
    public let symbol: String

    /// The bid exchange ID.
    public let bidExchange: Int

    /// The bid price.
    public let bidPrice: Double

    /// The bid size (in round lots of 100 shares).
    public let bidSize: Int

    /// The ask exchange ID.
    public let askExchange: Int

    /// The ask price.
    public let askPrice: Double

    /// The ask size (in round lots of 100 shares).
    public let askSize: Int

    /// The condition code.
    public let condition: Int?

    /// The indicators.
    public let indicators: [Int]?

    /// The SIP timestamp.
    public let timestamp: Timestamp

    /// The sequence number.
    public let sequenceNumber: Int64

    /// The tape (1 = NYSE, 2 = AMEX, 3 = Nasdaq).
    public let tape: Int

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "sym"
        case bidExchange = "bx"
        case bidPrice = "bp"
        case bidSize = "bs"
        case askExchange = "ax"
        case askPrice = "ap"
        case askSize = "as"
        case condition = "c"
        case indicators = "i"
        case timestamp = "t"
        case sequenceNumber = "q"
        case tape = "z"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decode(String.self, forKey: .eventType)
        symbol = try container.decode(String.self, forKey: .symbol)
        bidExchange = try container.decode(Int.self, forKey: .bidExchange)
        bidPrice = try container.decode(Double.self, forKey: .bidPrice)
        bidSize = try container.decode(Int.self, forKey: .bidSize)
        askExchange = try container.decode(Int.self, forKey: .askExchange)
        askPrice = try container.decode(Double.self, forKey: .askPrice)
        askSize = try container.decode(Int.self, forKey: .askSize)
        condition = try container.decodeIfPresent(Int.self, forKey: .condition)
        indicators = try container.decodeIfPresent([Int].self, forKey: .indicators)
        let timestampMs = try container.decode(Int64.self, forKey: .timestamp)
        timestamp = Timestamp(millisecondsSinceEpoch: timestampMs)
        sequenceNumber = try container.decode(Int64.self, forKey: .sequenceNumber)
        tape = try container.decode(Int.self, forKey: .tape)
    }
}
