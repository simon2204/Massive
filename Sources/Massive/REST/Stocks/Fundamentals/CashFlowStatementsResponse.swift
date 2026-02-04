import Foundation

/// Response from the Cash Flow Statements endpoint.
public struct CashFlowStatementsResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of cash flow statements.
    public let results: [CashFlowStatement]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// A cash flow statement from an SEC filing.
public struct CashFlowStatement: Codable, Sendable {
    /// Company's SEC Central Index Key.
    public let cik: String?

    /// Ticker symbols associated with this filing.
    public let tickers: [String]?

    /// Last date of the reporting period.
    public let periodEnd: String?

    /// SEC filing date.
    public let filingDate: String?

    /// Fiscal year.
    public let fiscalYear: Int?

    /// Fiscal quarter.
    public let fiscalQuarter: Int?

    /// Reporting timeframe.
    public let timeframe: String?

    // MARK: - Operating Activities

    /// Net cash from operating activities.
    public let netCashFromOperating: FinancialValue?

    /// Depreciation and amortization.
    public let depreciationAmortization: FinancialValue?

    // MARK: - Investing Activities

    /// Net cash from investing activities.
    public let netCashFromInvesting: FinancialValue?

    /// Capital expenditures.
    public let capitalExpenditures: FinancialValue?

    // MARK: - Financing Activities

    /// Net cash from financing activities.
    public let netCashFromFinancing: FinancialValue?

    /// Dividends paid.
    public let dividendsPaid: FinancialValue?

    /// Stock repurchases.
    public let stockRepurchases: FinancialValue?

    /// Debt repayment.
    public let debtRepayment: FinancialValue?

    // MARK: - Summary

    /// Net change in cash.
    public let netChangeInCash: FinancialValue?

    /// Free cash flow.
    public let freeCashFlow: FinancialValue?

    enum CodingKeys: String, CodingKey {
        case cik, tickers, timeframe
        case periodEnd = "period_end"
        case filingDate = "filing_date"
        case fiscalYear = "fiscal_year"
        case fiscalQuarter = "fiscal_quarter"
        case netCashFromOperating = "net_cash_from_operating"
        case depreciationAmortization = "depreciation_amortization"
        case netCashFromInvesting = "net_cash_from_investing"
        case capitalExpenditures = "capital_expenditures"
        case netCashFromFinancing = "net_cash_from_financing"
        case dividendsPaid = "dividends_paid"
        case stockRepurchases = "stock_repurchases"
        case debtRepayment = "debt_repayment"
        case netChangeInCash = "net_change_in_cash"
        case freeCashFlow = "free_cash_flow"
    }
}
