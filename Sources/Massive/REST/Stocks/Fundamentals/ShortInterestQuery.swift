import Foundation

/// Query parameters for the Short Interest endpoint.
///
/// Get short interest data showing the number of shares sold short.
///
/// Use Cases: Short squeeze analysis, sentiment indicators, risk assessment.
///
/// ## Example
/// ```swift
/// // Short interest for GME
/// let query = ShortInterestQuery(ticker: "GME")
/// ```
public struct ShortInterestQuery: APIQuery {
    /// The ticker symbol.
    public let ticker: Ticker?

    /// Settlement date (YYYY-MM-DD).
    public let settlementDate: String?

    /// Limit results (default 10, max 50000).
    public let limit: Int?

    /// Sort columns with direction.
    public let sort: String?

    public init(
        ticker: Ticker? = nil,
        settlementDate: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.settlementDate = settlementDate
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/v1/short-interest"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("settlement_date", settlementDate)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
