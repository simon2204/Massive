import Foundation

/// Query parameters for the Financial Ratios endpoint.
///
/// Get calculated financial ratios including valuation, profitability, and liquidity metrics.
///
/// Use Cases: Valuation analysis, peer comparison, screening.
///
/// ## Example
/// ```swift
/// // Ratios for AAPL
/// let query = RatiosQuery(ticker: "AAPL")
/// ```
public struct RatiosQuery: APIQuery {
    /// The ticker symbol.
    public let ticker: Ticker?

    /// Company's SEC Central Index Key.
    public let cik: String?

    /// Limit results (default 100, max 50000).
    public let limit: Int?

    /// Sort columns with direction.
    public let sort: String?

    public init(
        ticker: Ticker? = nil,
        cik: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.cik = cik
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/financials/v1/ratios"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("cik", cik)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
