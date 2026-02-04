import Foundation

/// A market data snapshot for a single ticker.
public struct TickerSnapshot: Codable, Sendable {
    /// The exchange symbol that this item is traded under.
    public let ticker: String?

    /// The most recent daily bar for this ticker.
    public let day: SnapshotBar?

    /// The previous day's bar for this ticker.
    public let prevDay: SnapshotBar?

    /// The most recent minute bar for this ticker.
    public let min: SnapshotBar?

    /// The most recent quote for this ticker (requires quotes in plan).
    public let lastQuote: SnapshotQuote?

    /// The most recent trade for this ticker (requires trades in plan).
    public let lastTrade: SnapshotTrade?

    /// Fair market value (Business plans only).
    public let fmv: Double?

    /// The value of the change from the previous day.
    public let todaysChange: Double?

    /// The percentage change since the previous day.
    public let todaysChangePerc: Double?

    /// The last updated timestamp.
    public let updated: Int?
}

/// A bar within a snapshot response.
public struct SnapshotBar: Codable, Sendable {
    /// The close price.
    public let close: Double?

    /// The highest price.
    public let high: Double?

    /// The lowest price.
    public let low: Double?

    /// The open price.
    public let open: Double?

    /// The trading volume.
    public let volume: Double?

    /// The volume weighted average price.
    public let vwap: Double?

    /// The number of transactions.
    public let transactions: Int?

    /// The Unix millisecond timestamp.
    public let timestamp: Int?

    /// Whether this is for an OTC ticker.
    public let otc: Bool?

    enum CodingKeys: String, CodingKey {
        case close = "c"
        case high = "h"
        case low = "l"
        case open = "o"
        case volume = "v"
        case vwap = "vw"
        case transactions = "n"
        case timestamp = "t"
        case otc
    }
}

/// A quote within a snapshot response.
public struct SnapshotQuote: Codable, Sendable {
    /// The bid price.
    public let bidPrice: Double?

    /// The bid size.
    public let bidSize: Int?

    /// The ask price.
    public let askPrice: Double?

    /// The ask size.
    public let askSize: Int?

    /// The Unix millisecond timestamp.
    public let timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case bidPrice = "p"
        case bidSize = "s"
        case askPrice = "P"
        case askSize = "S"
        case timestamp = "t"
    }
}

/// A trade within a snapshot response.
public struct SnapshotTrade: Codable, Sendable {
    /// The price of the trade.
    public let price: Double?

    /// The size of the trade.
    public let size: Int?

    /// The exchange the trade occurred on.
    public let exchange: Int?

    /// The conditions of the trade.
    public let conditions: [Int]?

    /// The trade ID.
    public let tradeId: String?

    /// The Unix millisecond timestamp.
    public let timestamp: Int?

    enum CodingKeys: String, CodingKey {
        case price = "p"
        case size = "s"
        case exchange = "x"
        case conditions = "c"
        case tradeId = "i"
        case timestamp = "t"
    }
}

/// Direction for top market movers.
public enum MoverDirection: String, Sendable, CaseIterable {
    case gainers
    case losers
}
