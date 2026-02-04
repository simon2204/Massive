import Foundation

/// Response from the Balance Sheets endpoint.
public struct BalanceSheetsResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of balance sheets.
    public let results: [BalanceSheet]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// A balance sheet from an SEC filing.
public struct BalanceSheet: Codable, Sendable {
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

    // MARK: - Assets

    /// Total assets.
    public let totalAssets: FinancialValue?

    /// Current assets.
    public let currentAssets: FinancialValue?

    /// Cash and cash equivalents.
    public let cash: FinancialValue?

    /// Accounts receivable.
    public let accountsReceivable: FinancialValue?

    /// Inventory.
    public let inventory: FinancialValue?

    /// Property, plant, and equipment.
    public let propertyPlantEquipment: FinancialValue?

    /// Goodwill.
    public let goodwill: FinancialValue?

    /// Intangible assets.
    public let intangibleAssets: FinancialValue?

    // MARK: - Liabilities

    /// Total liabilities.
    public let totalLiabilities: FinancialValue?

    /// Current liabilities.
    public let currentLiabilities: FinancialValue?

    /// Accounts payable.
    public let accountsPayable: FinancialValue?

    /// Long-term debt.
    public let longTermDebt: FinancialValue?

    /// Short-term debt.
    public let shortTermDebt: FinancialValue?

    // MARK: - Equity

    /// Total stockholders' equity.
    public let totalEquity: FinancialValue?

    /// Retained earnings.
    public let retainedEarnings: FinancialValue?

    /// Common stock.
    public let commonStock: FinancialValue?

    /// Treasury stock.
    public let treasuryStock: FinancialValue?

    enum CodingKeys: String, CodingKey {
        case cik, tickers, timeframe
        case periodEnd = "period_end"
        case filingDate = "filing_date"
        case fiscalYear = "fiscal_year"
        case fiscalQuarter = "fiscal_quarter"
        case totalAssets = "total_assets"
        case currentAssets = "current_assets"
        case cash
        case accountsReceivable = "accounts_receivable"
        case inventory
        case propertyPlantEquipment = "property_plant_equipment"
        case goodwill
        case intangibleAssets = "intangible_assets"
        case totalLiabilities = "total_liabilities"
        case currentLiabilities = "current_liabilities"
        case accountsPayable = "accounts_payable"
        case longTermDebt = "long_term_debt"
        case shortTermDebt = "short_term_debt"
        case totalEquity = "total_equity"
        case retainedEarnings = "retained_earnings"
        case commonStock = "common_stock"
        case treasuryStock = "treasury_stock"
    }
}
