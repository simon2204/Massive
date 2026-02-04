import Foundation

/// Response from the Daily Market Summary (Grouped Daily) endpoint.
public struct DailyMarketSummaryResponse: Codable, Sendable {
    /// Whether or not this response was adjusted for splits.
    public let adjusted: Bool

    /// The number of aggregates used to generate the response.
    public let queryCount: Int

    /// A request ID assigned by the server.
    public let requestId: String

    /// The total number of results for this request.
    public let resultsCount: Int

    /// The status of this request's response.
    public let status: String

    /// An array of OHLC bar results for all tickers.
    public let results: [MarketBar]?
}

/// A single OHLC bar for a ticker in the market summary.
public struct MarketBar: Codable, Sendable {
    /// The exchange symbol that this item is traded under.
    public let ticker: String

    /// The close price for the symbol in the given time period.
    public let close: Double

    /// The highest price for the symbol in the given time period.
    public let high: Double

    /// The lowest price for the symbol in the given time period.
    public let low: Double

    /// The number of transactions in the aggregate window.
    public let transactions: Int?

    /// The open price for the symbol in the given time period.
    public let open: Double

    /// Whether or not this aggregate is for an OTC ticker.
    public let otc: Bool?

    /// The Unix millisecond timestamp for the end of the aggregate window.
    public let timestamp: Int

    /// The trading volume of the symbol in the given time period.
    public let volume: Double

    /// The volume weighted average price.
    public let vwap: Double?

    enum CodingKeys: String, CodingKey {
        case ticker = "T"
        case close = "c"
        case high = "h"
        case low = "l"
        case transactions = "n"
        case open = "o"
        case otc
        case timestamp = "t"
        case volume = "v"
        case vwap = "vw"
    }
}
