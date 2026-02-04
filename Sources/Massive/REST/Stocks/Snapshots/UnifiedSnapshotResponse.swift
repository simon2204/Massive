import Foundation

/// Response from the Universal Snapshot endpoint.
public struct UnifiedSnapshotResponse: Codable, Sendable {
    /// The status of this request's response.
    public let status: String?

    /// A request ID assigned by the server.
    public let requestId: String?

    /// An array of unified snapshots for all requested tickers.
    public let results: [UnifiedSnapshot]?

    enum CodingKeys: String, CodingKey {
        case status
        case requestId = "request_id"
        case results
    }
}

/// A unified snapshot that can represent stocks, options, indices, forex, or crypto.
public struct UnifiedSnapshot: Codable, Sendable {
    /// The ticker symbol.
    public let ticker: String?

    /// The type of asset (stocks, options, fx, crypto, indices).
    public let type: String?

    /// The market status.
    public let marketStatus: String?

    /// Session data containing current trading session info.
    public let session: UnifiedSnapshotSession?

    /// The last quote for this ticker.
    public let lastQuote: UnifiedSnapshotQuote?

    /// The last trade for this ticker.
    public let lastTrade: UnifiedSnapshotTrade?

    /// Fair market value (Business plans only).
    public let fmv: Double?

    enum CodingKeys: String, CodingKey {
        case ticker
        case type
        case marketStatus = "market_status"
        case session
        case lastQuote = "last_quote"
        case lastTrade = "last_trade"
        case fmv
    }
}

/// Session data within a unified snapshot.
public struct UnifiedSnapshotSession: Codable, Sendable {
    /// The change in price.
    public let change: Double?

    /// The percent change in price.
    public let changePercent: Double?

    /// The close price.
    public let close: Double?

    /// The high price.
    public let high: Double?

    /// The low price.
    public let low: Double?

    /// The open price.
    public let open: Double?

    /// The previous close price.
    public let previousClose: Double?

    /// The trading volume.
    public let volume: Double?

    enum CodingKeys: String, CodingKey {
        case change
        case changePercent = "change_percent"
        case close
        case high
        case low
        case open
        case previousClose = "previous_close"
        case volume
    }
}

/// Quote data within a unified snapshot.
public struct UnifiedSnapshotQuote: Codable, Sendable {
    /// The ask price.
    public let ask: Double?

    /// The ask size.
    public let askSize: Double?

    /// The bid price.
    public let bid: Double?

    /// The bid size.
    public let bidSize: Double?

    /// The Unix nanosecond timestamp.
    public let lastUpdated: Int?

    enum CodingKeys: String, CodingKey {
        case ask
        case askSize = "ask_size"
        case bid
        case bidSize = "bid_size"
        case lastUpdated = "last_updated"
    }
}

/// Trade data within a unified snapshot.
public struct UnifiedSnapshotTrade: Codable, Sendable {
    /// The trade price.
    public let price: Double?

    /// The trade size.
    public let size: Double?

    /// The exchange the trade occurred on.
    public let exchange: Int?

    /// The trade conditions.
    public let conditions: [Int]?

    /// The trade ID.
    public let id: String?

    /// The Unix nanosecond timestamp.
    public let lastUpdated: Int?

    enum CodingKeys: String, CodingKey {
        case price
        case size
        case exchange
        case conditions
        case id
        case lastUpdated = "last_updated"
    }
}
