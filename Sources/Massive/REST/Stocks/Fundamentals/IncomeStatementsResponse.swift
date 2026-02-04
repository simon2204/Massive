import Foundation

/// Response from the Income Statements endpoint.
public struct IncomeStatementsResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of income statements.
    public let results: [IncomeStatement]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// An income statement from an SEC filing.
public struct IncomeStatement: Codable, Sendable {
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

    // MARK: - Revenue

    /// Total revenue.
    public let totalRevenue: FinancialValue?

    /// Cost of revenue.
    public let costOfRevenue: FinancialValue?

    /// Gross profit.
    public let grossProfit: FinancialValue?

    // MARK: - Operating Expenses

    /// Operating expenses.
    public let operatingExpenses: FinancialValue?

    /// Research and development.
    public let researchAndDevelopment: FinancialValue?

    /// Selling, general and administrative.
    public let sellingGeneralAdmin: FinancialValue?

    // MARK: - Income

    /// Operating income.
    public let operatingIncome: FinancialValue?

    /// Income before taxes.
    public let incomeBeforeTaxes: FinancialValue?

    /// Income tax expense.
    public let incomeTaxExpense: FinancialValue?

    /// Net income.
    public let netIncome: FinancialValue?

    // MARK: - Per Share

    /// Basic earnings per share.
    public let basicEPS: FinancialValue?

    /// Diluted earnings per share.
    public let dilutedEPS: FinancialValue?

    /// Basic weighted average shares.
    public let basicShares: FinancialValue?

    /// Diluted weighted average shares.
    public let dilutedShares: FinancialValue?

    enum CodingKeys: String, CodingKey {
        case cik, tickers, timeframe
        case periodEnd = "period_end"
        case filingDate = "filing_date"
        case fiscalYear = "fiscal_year"
        case fiscalQuarter = "fiscal_quarter"
        case totalRevenue = "total_revenue"
        case costOfRevenue = "cost_of_revenue"
        case grossProfit = "gross_profit"
        case operatingExpenses = "operating_expenses"
        case researchAndDevelopment = "research_and_development"
        case sellingGeneralAdmin = "selling_general_admin"
        case operatingIncome = "operating_income"
        case incomeBeforeTaxes = "income_before_taxes"
        case incomeTaxExpense = "income_tax_expense"
        case netIncome = "net_income"
        case basicEPS = "basic_eps"
        case dilutedEPS = "diluted_eps"
        case basicShares = "basic_shares"
        case dilutedShares = "diluted_shares"
    }
}
