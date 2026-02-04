import Foundation

/// Query parameters for the Daily Ticker Summary (Open/Close) endpoint.
///
/// Retrieves the open, close, and after-hours prices of a stock symbol on a certain date.
/// Includes pre-market and after-hours trading prices when available.
///
/// Use Cases: Daily performance analysis, historical data collection, extended hours analysis.
///
/// ## Example
/// ```swift
/// let query = DailyTickerSummaryQuery(ticker: "AAPL", date: "2024-01-15")
///
/// // Unadjusted for splits
/// let query = DailyTickerSummaryQuery(ticker: "AAPL", date: "2024-01-15", adjusted: false)
/// ```
public struct DailyTickerSummaryQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    /// The date of the requested open/close (YYYY-MM-DD format).
    public let date: String

    /// Whether or not the results are adjusted for splits. Default is true.
    public let adjusted: Bool?

    public init(ticker: Ticker, date: String, adjusted: Bool? = nil) {
        self.ticker = ticker
        self.date = date
        self.adjusted = adjusted
    }

    public var path: String {
        "/v1/open-close/\(ticker.symbol)/\(date)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("adjusted", adjusted)
        return builder.build()
    }
}
