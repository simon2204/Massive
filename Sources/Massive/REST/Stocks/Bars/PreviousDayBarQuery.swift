import Foundation

/// Query parameters for the Previous Day Bar endpoint.
///
/// Retrieves the previous day's open, high, low, and close (OHLC) for the
/// specified stock ticker.
///
/// Use Cases: Baseline comparison, technical analysis, market research, daily reporting.
///
/// ## Example
/// ```swift
/// let query = PreviousDayBarQuery(ticker: "AAPL")
///
/// // Unadjusted for splits
/// let query = PreviousDayBarQuery(ticker: "AAPL", adjusted: false)
/// ```
public struct PreviousDayBarQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    /// Whether or not the results are adjusted for splits. Default is true.
    public let adjusted: Bool?

    public init(ticker: Ticker, adjusted: Bool? = nil) {
        self.ticker = ticker
        self.adjusted = adjusted
    }

    public var path: String {
        "/v2/aggs/ticker/\(ticker.symbol)/prev"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("adjusted", adjusted)
        return builder.build()
    }
}
