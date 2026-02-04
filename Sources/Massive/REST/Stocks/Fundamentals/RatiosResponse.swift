import Foundation

/// Response from the Financial Ratios endpoint.
public struct RatiosResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of financial ratios.
    public let results: [FinancialRatios]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// Financial ratios for a company on a specific date.
public struct FinancialRatios: Codable, Sendable {
    /// The ticker symbol.
    public let ticker: String?

    /// Company's SEC Central Index Key.
    public let cik: String?

    /// The trading date for these ratios.
    public let date: String?

    /// Stock closing price.
    public let price: Double?

    /// Average trading volume (30 days).
    public let averageVolume: Double?

    /// Market capitalization.
    public let marketCap: Double?

    /// Enterprise value.
    public let enterpriseValue: Double?

    // MARK: - Valuation Ratios

    /// Earnings per share.
    public let earningsPerShare: Double?

    /// Price-to-earnings ratio.
    public let priceToEarnings: Double?

    /// Price-to-book ratio.
    public let priceToBook: Double?

    /// Price-to-sales ratio.
    public let priceToSales: Double?

    /// Price-to-cash-flow ratio.
    public let priceToCashFlow: Double?

    /// Price-to-free-cash-flow ratio.
    public let priceToFreeCashFlow: Double?

    /// EV/Sales ratio.
    public let evToSales: Double?

    /// EV/EBITDA ratio.
    public let evToEbitda: Double?

    // MARK: - Profitability Ratios

    /// Return on assets.
    public let returnOnAssets: Double?

    /// Return on equity.
    public let returnOnEquity: Double?

    /// Dividend yield.
    public let dividendYield: Double?

    // MARK: - Liquidity Ratios

    /// Current ratio.
    public let current: Double?

    /// Quick ratio.
    public let quick: Double?

    /// Cash ratio.
    public let cash: Double?

    /// Debt-to-equity ratio.
    public let debtToEquity: Double?

    // MARK: - Cash Flow

    /// Free cash flow.
    public let freeCashFlow: Double?

    enum CodingKeys: String, CodingKey {
        case ticker, cik, date, price, current, quick, cash
        case averageVolume = "average_volume"
        case marketCap = "market_cap"
        case enterpriseValue = "enterprise_value"
        case earningsPerShare = "earnings_per_share"
        case priceToEarnings = "price_to_earnings"
        case priceToBook = "price_to_book"
        case priceToSales = "price_to_sales"
        case priceToCashFlow = "price_to_cash_flow"
        case priceToFreeCashFlow = "price_to_free_cash_flow"
        case evToSales = "ev_to_sales"
        case evToEbitda = "ev_to_ebitda"
        case returnOnAssets = "return_on_assets"
        case returnOnEquity = "return_on_equity"
        case dividendYield = "dividend_yield"
        case debtToEquity = "debt_to_equity"
        case freeCashFlow = "free_cash_flow"
    }
}
