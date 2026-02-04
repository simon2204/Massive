import Foundation

/// Query parameters for the Daily Market Summary (Grouped Daily) endpoint.
///
/// Retrieves the daily open, high, low, and close (OHLC) for the entire
/// US stocks market on a specific date.
///
/// Use Cases: Market overview, sector analysis, screening, daily reports.
///
/// ## Example
/// ```swift
/// let query = DailyMarketSummaryQuery(date: "2024-01-15")
///
/// // Include OTC securities
/// let query = DailyMarketSummaryQuery(date: "2024-01-15", includeOtc: true)
/// ```
public struct DailyMarketSummaryQuery: APIQuery {
    /// The date for the aggregate window (YYYY-MM-DD format).
    public let date: String

    /// Whether or not the results are adjusted for splits. Default is true.
    public let adjusted: Bool?

    /// Include OTC securities in the response. Default is false.
    public let includeOtc: Bool?

    public init(date: String, adjusted: Bool? = nil, includeOtc: Bool? = nil) {
        self.date = date
        self.adjusted = adjusted
        self.includeOtc = includeOtc
    }

    public var path: String {
        "/v2/aggs/grouped/locale/us/market/stocks/\(date)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("adjusted", adjusted)
        builder.add("include_otc", includeOtc)
        return builder.build()
    }
}
