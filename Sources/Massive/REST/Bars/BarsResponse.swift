import Foundation

/// Response from the Custom Bars (OHLC) endpoint.
public struct BarsResponse: Codable, PaginatedResponse {
    /// The exchange symbol that this item is traded under.
    public let ticker: Ticker

    /// Whether or not this response was adjusted for splits.
    public let adjusted: Bool

    /// The number of aggregates (minute or day) used to generate the response.
    public let queryCount: Int

    /// A request ID assigned by the server.
    public let requestId: String

    /// The total number of results for this request.
    public let resultsCount: Int

    /// The status of this request's response.
    public let status: String

    /// An array of OHLC bar results.
    public let results: [Bar]?

    /// If present, this value can be used to fetch the next page of data.
    public let nextUrl: String?
}

/// A single OHLC bar representing price and volume data for a time period.
public struct Bar: Codable, Sendable {
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

    /// The Unix millisecond timestamp for the start of the aggregate window.
    public let t: Int

    /// The trading volume of the symbol in the given time period.
    public let v: Double

    /// The volume weighted average price.
    public let vw: Double?

    /// Whether or not this aggregate is for an OTC ticker.
    public let otc: Bool?
}
