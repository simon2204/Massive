import Foundation

/// Query parameters for the Labor Market endpoint.
///
/// Retrieves labor market indicators including unemployment and job openings.
///
/// Use Cases: Employment analysis, economic forecasting, policy research.
///
/// ## Example
/// ```swift
/// // Get latest labor market data
/// let query = LaborMarketQuery()
///
/// // Get data for a specific date
/// let query = LaborMarketQuery(date: "2024-01-15")
/// ```
public struct LaborMarketQuery: APIQuery {
    /// Calendar date of the observation (YYYY-MM-DD).
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
        "/fed/v1/labor-market"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("date", date)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
