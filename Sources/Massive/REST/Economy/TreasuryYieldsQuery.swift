import Foundation

/// Query parameters for the Treasury Yields endpoint.
///
/// Retrieves daily Treasury yield curve data from Federal Reserve sources.
///
/// Use Cases: Fixed income analysis, yield curve modeling, economic research.
///
/// ## Example
/// ```swift
/// // Get latest Treasury yields
/// let query = TreasuryYieldsQuery()
///
/// // Get yields for a specific date
/// let query = TreasuryYieldsQuery(date: "2024-01-15")
/// ```
public struct TreasuryYieldsQuery: APIQuery {
    /// Calendar date of the yield observation (YYYY-MM-DD).
    public let date: String?

    /// Maximum results (default 100, max 50000).
    public let limit: Int?

    /// Sort columns with direction (default "date.asc").
    public let sort: String?

    public init(
        date: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.date = date
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/fed/v1/treasury-yields"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("date", date)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
