import Foundation

/// Query parameters for the Float endpoint.
///
/// Get float data showing shares available for public trading.
///
/// Use Cases: Liquidity analysis, short squeeze potential, ownership analysis.
///
/// ## Example
/// ```swift
/// // Float for AAPL
/// let query = FloatQuery(ticker: "AAPL")
/// ```
public struct FloatQuery: APIQuery {
    /// The ticker symbol.
    public let ticker: Ticker?

    /// Limit results (default 100, max 5000).
    public let limit: Int?

    /// Sort columns with direction.
    public let sort: String?

    public init(
        ticker: Ticker? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/vX/float"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
