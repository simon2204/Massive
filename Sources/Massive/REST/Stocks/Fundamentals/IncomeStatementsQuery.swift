import Foundation

/// Query parameters for the Income Statements endpoint.
///
/// Get income statement data from SEC filings including revenue, expenses, and earnings.
///
/// Use Cases: Profitability analysis, earnings trends, margin calculations.
///
/// ## Example
/// ```swift
/// // Latest income statements for AAPL
/// let query = IncomeStatementsQuery(tickers: "AAPL")
///
/// // Q4 2023 results
/// let query = IncomeStatementsQuery(tickers: "AAPL", fiscalYear: 2023, fiscalQuarter: 4)
/// ```
public struct IncomeStatementsQuery: APIQuery {
    /// Filter by ticker symbol(s).
    public var tickers: String?

    /// Company's SEC Central Index Key.
    public var cik: String?

    /// Last date of the reporting period (YYYY-MM-DD).
    public var periodEnd: String?

    /// SEC filing date (YYYY-MM-DD).
    public var filingDate: String?

    /// Fiscal year.
    public var fiscalYear: Int?

    /// Fiscal quarter (1, 2, 3, or 4).
    public var fiscalQuarter: Int?

    /// Reporting period type.
    public var timeframe: FinancialTimeframe?

    /// Limit results (default 100, max 50000).
    public var limit: Int?

    /// Sort columns with direction.
    public var sort: String?

    public init(
        tickers: String? = nil,
        cik: String? = nil,
        periodEnd: String? = nil,
        filingDate: String? = nil,
        fiscalYear: Int? = nil,
        fiscalQuarter: Int? = nil,
        timeframe: FinancialTimeframe? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.tickers = tickers
        self.cik = cik
        self.periodEnd = periodEnd
        self.filingDate = filingDate
        self.fiscalYear = fiscalYear
        self.fiscalQuarter = fiscalQuarter
        self.timeframe = timeframe
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/financials/v1/income-statements"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("tickers", tickers)
        builder.add("cik", cik)
        builder.add("period_end", periodEnd)
        builder.add("filing_date", filingDate)
        builder.add("fiscal_year", fiscalYear)
        builder.add("fiscal_quarter", fiscalQuarter)
        builder.add("timeframe", timeframe)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
