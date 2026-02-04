import Foundation

/// Query parameters for the Related Tickers endpoint.
///
/// Get a list of tickers related to the queried ticker based on news
/// and returns data.
///
/// Use Cases: Peer identification, comparative analysis, portfolio diversification, market research.
///
/// ## Example
/// ```swift
/// let query = RelatedTickersQuery(ticker: "AAPL")
/// ```
public struct RelatedTickersQuery: APIQuery {
    /// The ticker symbol to find related companies for.
    public let ticker: Ticker

    public init(ticker: Ticker) {
        self.ticker = ticker
    }

    public var path: String {
        "/v1/related-companies/\(ticker.symbol)"
    }

    public var queryItems: [URLQueryItem]? {
        nil
    }
}
