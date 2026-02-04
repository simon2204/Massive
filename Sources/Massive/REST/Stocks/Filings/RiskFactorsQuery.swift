import Foundation

/// Query parameters for the Risk Factors endpoint.
///
/// Retrieves categorized risk factors from SEC filings with AI-powered classification.
///
/// Use Cases: Risk analysis, compliance monitoring, due diligence.
///
/// ## Example
/// ```swift
/// // Get all risk factors for AAPL
/// let query = RiskFactorsQuery(ticker: "AAPL")
///
/// // Get risk factors from a specific filing date
/// let query = RiskFactorsQuery(ticker: "AAPL", filingDate: "2024-01-15")
/// ```
public struct RiskFactorsQuery: APIQuery {
    /// Filing submission date (YYYY-MM-DD).
    public var filingDate: String?

    /// Stock ticker symbol.
    public var ticker: String?

    /// SEC Central Index Key (10 digits, zero-padded).
    public var cik: String?

    /// Maximum results (default 100, max 49999).
    public var limit: Int?

    /// Sort columns with direction.
    public var sort: String?

    public init(
        filingDate: String? = nil,
        ticker: String? = nil,
        cik: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.filingDate = filingDate
        self.ticker = ticker
        self.cik = cik
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/filings/v1/risk-factors"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("filing_date", filingDate)
        builder.add("ticker", ticker)
        builder.add("cik", cik)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
