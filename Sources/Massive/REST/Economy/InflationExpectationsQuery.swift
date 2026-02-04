import Foundation

/// Query parameters for the Inflation Expectations endpoint.
///
/// Retrieves market-based and model-based inflation expectations.
///
/// Use Cases: Inflation forecasting, fixed income analysis, monetary policy research.
///
/// ## Example
/// ```swift
/// // Get latest inflation expectations
/// let query = InflationExpectationsQuery()
///
/// // Get expectations for a specific date
/// let query = InflationExpectationsQuery(date: "2024-01-15")
/// ```
public struct InflationExpectationsQuery: APIQuery {
    /// Calendar date of the observation (YYYY-MM-DD).
    public let date: String?

    /// Maximum results (default 100, max 50000).
    public let limit: Int?

    /// Sort columns with direction.
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
        "/fed/v1/inflation-expectations"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("date", date)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
