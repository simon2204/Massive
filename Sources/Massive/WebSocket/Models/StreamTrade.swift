import Fetch
import Foundation

/// Real-time trade data from WebSocket stream.
public struct StreamTrade: Sendable, Decodable {
    /// The event type (`T`).
    public let eventType: String

    /// The ticker symbol.
    public let symbol: String

    /// The exchange ID.
    public let exchange: Int

    /// The trade ID.
    public let tradeId: String

    /// The tape (1 = NYSE, 2 = AMEX, 3 = Nasdaq).
    public let tape: Int

    /// The trade price.
    public let price: Double

    /// The trade size (number of shares).
    public let size: Int

    /// The trade conditions.
    public let conditions: [Int]?

    /// The SIP timestamp.
    public let timestamp: Timestamp

    /// The sequence number.
    public let sequenceNumber: Int64

    /// The Trade Reporting Facility ID.
    public let trfId: Int?

    /// The TRF timestamp.
    public let trfTimestamp: Timestamp?

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "sym"
        case exchange = "x"
        case tradeId = "i"
        case tape = "z"
        case price = "p"
        case size = "s"
        case conditions = "c"
        case timestamp = "t"
        case sequenceNumber = "q"
        case trfId = "trfi"
        case trfTimestamp = "trft"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventType = try container.decode(String.self, forKey: .eventType)
        symbol = try container.decode(String.self, forKey: .symbol)
        exchange = try container.decode(Int.self, forKey: .exchange)
        tradeId = try container.decode(String.self, forKey: .tradeId)
        tape = try container.decode(Int.self, forKey: .tape)
        price = try container.decode(Double.self, forKey: .price)
        size = try container.decode(Int.self, forKey: .size)
        conditions = try container.decodeIfPresent([Int].self, forKey: .conditions)
        let timestampMs = try container.decode(Int64.self, forKey: .timestamp)
        timestamp = Timestamp(millisecondsSinceEpoch: timestampMs)
        sequenceNumber = try container.decode(Int64.self, forKey: .sequenceNumber)
        trfId = try container.decodeIfPresent(Int.self, forKey: .trfId)
        if let trfMs = try container.decodeIfPresent(Int64.self, forKey: .trfTimestamp) {
            trfTimestamp = Timestamp(millisecondsSinceEpoch: trfMs)
        } else {
            trfTimestamp = nil
        }
    }
}
