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
    public let T: String

    /// The close price for the symbol in the given time period.
    public let c: Double

    /// The highest price for the symbol in the given time period.
    public let h: Double

    /// The lowest price for the symbol in the given time period.
    public let l: Double

    /// The number of transactions in the aggregate window.
    public let n: Int?

    /// The open price for the symbol in the given time period.
    public let o: Double

    /// Whether or not this aggregate is for an OTC ticker.
    public let otc: Bool?

    /// The Unix millisecond timestamp for the end of the aggregate window.
    public let t: Int

    /// The trading volume of the symbol in the given time period.
    public let v: Double

    /// The volume weighted average price.
    public let vw: Double?
}
