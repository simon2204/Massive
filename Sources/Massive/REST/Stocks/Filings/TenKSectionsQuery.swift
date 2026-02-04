import Foundation

/// Query parameters for the 10-K Sections endpoint.
///
/// Retrieves full text content from specific sections of 10-K SEC filings.
///
/// Use Cases: Fundamental analysis, automated document processing, research.
///
/// ## Example
/// ```swift
/// // Get business description for AAPL
/// let query = TenKSectionsQuery(ticker: "AAPL", section: .business)
///
/// // Get risk factors from a specific filing
/// let query = TenKSectionsQuery(ticker: "AAPL", section: .riskFactors, filingDate: "2024-01-15")
/// ```
public struct TenKSectionsQuery: APIQuery {
    /// SEC Central Index Key (10 digits, zero-padded).
    public var cik: String?

    /// Stock ticker symbol.
    public var ticker: String?

    /// Standardized section identifier.
    public var section: TenKSection?

    /// Filing submission date (YYYY-MM-DD).
    public var filingDate: String?

    /// Period end date (YYYY-MM-DD).
    public var periodEnd: String?

    /// Maximum results (default 100, max 9999).
    public var limit: Int?

    /// Sort columns with direction (e.g., "period_end.desc").
    public var sort: String?

    public init(
        cik: String? = nil,
        ticker: String? = nil,
        section: TenKSection? = nil,
        filingDate: String? = nil,
        periodEnd: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.cik = cik
        self.ticker = ticker
        self.section = section
        self.filingDate = filingDate
        self.periodEnd = periodEnd
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/filings/10-K/v1/sections"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("cik", cik)
        builder.add("ticker", ticker)
        builder.add("section", section)
        builder.add("filing_date", filingDate)
        builder.add("period_end", periodEnd)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
