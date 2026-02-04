import Foundation

/// Query parameters for the Dividends endpoint.
///
/// Get historical dividend data including cash amounts, dates, and distribution types.
///
/// Use Cases: Dividend tracking, income analysis, yield calculations.
///
/// ## Example
/// ```swift
/// // All dividends for AAPL
/// let query = DividendsQuery(ticker: "AAPL")
///
/// // Quarterly dividends only
/// let query = DividendsQuery(ticker: "AAPL", frequency: .quarterly)
///
/// // Special dividends
/// let query = DividendsQuery(distributionType: .special)
/// ```
public struct DividendsQuery: APIQuery {
    /// The ticker symbol.
    public let ticker: Ticker?

    /// Ex-dividend date (YYYY-MM-DD).
    public let exDividendDate: String?

    /// Distribution frequency.
    public let frequency: DividendFrequency?

    /// Type of distribution.
    public let distributionType: DividendDistributionType?

    /// Limit the number of results (default 100, max 5000).
    public let limit: Int?

    /// Sort columns with direction (e.g., "ex_dividend_date.desc").
    public let sort: String?

    public init(
        ticker: Ticker? = nil,
        exDividendDate: String? = nil,
        frequency: DividendFrequency? = nil,
        distributionType: DividendDistributionType? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.exDividendDate = exDividendDate
        self.frequency = frequency
        self.distributionType = distributionType
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/v1/dividends"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("ex_dividend_date", exDividendDate)
        if let frequency {
            builder.add("frequency", frequency.rawValue)
        }
        builder.add("distribution_type", distributionType)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
