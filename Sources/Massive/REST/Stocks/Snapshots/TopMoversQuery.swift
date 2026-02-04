import Foundation

/// Query parameters for the Top Market Movers endpoint.
///
/// Get the current top 20 gainers or losers of the day in the stocks/equities markets.
///
/// Use Cases: Market scanning, identifying momentum stocks, daily summaries.
///
/// ## Example
/// ```swift
/// // Get top gainers
/// let gainers = try await client.topMovers(TopMoversQuery(direction: .gainers))
///
/// // Get top losers
/// let losers = try await client.topMovers(TopMoversQuery(direction: .losers))
/// ```
public struct TopMoversQuery: APIQuery {
    /// The direction of the movers (gainers or losers).
    public let direction: MoverDirection

    /// Include OTC securities.
    public let includeOtc: Bool?

    public init(direction: MoverDirection, includeOtc: Bool? = nil) {
        self.direction = direction
        self.includeOtc = includeOtc
    }

    public var path: String {
        "/v2/snapshot/locale/us/markets/stocks/\(direction.rawValue)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("include_otc", includeOtc)
        return builder.build()
    }
}
