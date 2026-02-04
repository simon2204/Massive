import Foundation

/// Query parameters for the Short Volume endpoint.
///
/// Get daily short volume data showing short selling activity.
///
/// Use Cases: Short selling trends, market sentiment, trading signals.
///
/// ## Example
/// ```swift
/// // Short volume for GME
/// let query = ShortVolumeQuery(ticker: "GME")
///
/// // Specific date
/// let query = ShortVolumeQuery(ticker: "GME", date: "2024-01-15")
/// ```
public struct ShortVolumeQuery: APIQuery {
    /// The ticker symbol.
    public let ticker: Ticker?

    /// Trade date (YYYY-MM-DD).
    public let date: String?

    /// Limit results (default 10, max 50000).
    public let limit: Int?

    /// Sort columns with direction.
    public let sort: String?

    public init(
        ticker: Ticker? = nil,
        date: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.date = date
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/v1/short-volume"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("date", date)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
