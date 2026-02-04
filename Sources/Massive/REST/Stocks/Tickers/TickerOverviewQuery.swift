import Foundation

/// Query parameters for the Ticker Overview endpoint.
///
/// Retrieve comprehensive details for a single ticker supported by Massive.
/// This endpoint offers a deep look into a company's fundamental attributes
/// including name, description, market cap, address, and more.
///
/// Use Cases: Company research, fundamental analysis, due diligence.
///
/// ## Example
/// ```swift
/// // Get current ticker details
/// let query = TickerOverviewQuery(ticker: "AAPL")
///
/// // Get ticker details as of a specific date
/// let query = TickerOverviewQuery(ticker: "AAPL", date: "2024-01-15")
/// ```
public struct TickerOverviewQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    /// Specify a point in time to get information about the ticker available on that date.
    /// When retrieving information from SEC filings, this date is compared with the
    /// period of report date on the SEC filing.
    public var date: String?

    public init(ticker: Ticker, date: String? = nil) {
        self.ticker = ticker
        self.date = date
    }

    public var path: String {
        "/v3/reference/tickers/\(ticker.symbol)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("date", date)
        return builder.build()
    }
}
