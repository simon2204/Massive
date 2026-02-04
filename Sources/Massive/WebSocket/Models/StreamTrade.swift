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

    /// The SIP timestamp in Unix milliseconds.
    public let timestamp: Int64

    /// The sequence number.
    public let sequenceNumber: Int64

    /// The Trade Reporting Facility ID.
    public let trfId: Int?

    /// The TRF timestamp in Unix milliseconds.
    public let trfTimestamp: Int64?

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
}
