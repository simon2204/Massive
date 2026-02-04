import Foundation

/// Response from the Related Tickers endpoint.
public struct RelatedTickersResponse: Codable, Sendable {
    /// A request ID assigned by the server.
    public let requestId: String?

    /// An array of related tickers.
    public let results: [RelatedTicker]?

    /// The status of this request's response.
    public let status: String?

    /// The ticker being queried.
    public let ticker: Ticker?
}

/// A ticker related to the queried ticker.
public struct RelatedTicker: Codable, Sendable {
    /// The related ticker symbol.
    public let ticker: Ticker
}
