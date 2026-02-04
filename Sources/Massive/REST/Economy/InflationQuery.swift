import Foundation

/// Query parameters for the Inflation endpoint.
///
/// Retrieves inflation indicators including CPI and PCE data.
///
/// Use Cases: Inflation analysis, monetary policy research, economic forecasting.
///
/// ## Example
/// ```swift
/// // Get latest inflation data
/// let query = InflationQuery()
///
/// // Get inflation for a specific date
/// let query = InflationQuery(date: "2024-01-15")
/// ```
public struct InflationQuery: APIQuery {
    /// Calendar date of the observation (YYYY-MM-DD).
    public var date: String?

    /// Maximum results (default 100, max 50000).
    public var limit: Int?

    /// Sort columns with direction.
    public var sort: String?

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
        "/fed/v1/inflation"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("date", date)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
