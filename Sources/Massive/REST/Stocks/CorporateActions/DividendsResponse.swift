import Foundation

/// Response from the Dividends endpoint.
public struct DividendsResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of dividends.
    public let results: [Dividend]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// A dividend distribution event.
public struct Dividend: Codable, Sendable {
    /// Unique identifier for this dividend.
    public let id: String?

    /// The ticker symbol.
    public let ticker: String?

    /// Cash amount per share.
    public let cashAmount: Double?

    /// Currency code for the payment.
    public let currency: String?

    /// Date the dividend was announced.
    public let declarationDate: String?

    /// Ex-dividend date (trading begins without dividend).
    public let exDividendDate: String?

    /// Record date (shareholder eligibility cutoff).
    public let recordDate: String?

    /// Payment date.
    public let payDate: String?

    /// Type of distribution.
    public let distributionType: String?

    /// Annual distribution frequency.
    public let frequency: Int?

    /// Split-adjusted cash amount.
    public let splitAdjustedCashAmount: Double?

    /// Historical adjustment factor for price normalization.
    public let historicalAdjustmentFactor: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case ticker
        case cashAmount = "cash_amount"
        case currency
        case declarationDate = "declaration_date"
        case exDividendDate = "ex_dividend_date"
        case recordDate = "record_date"
        case payDate = "pay_date"
        case distributionType = "distribution_type"
        case frequency
        case splitAdjustedCashAmount = "split_adjusted_cash_amount"
        case historicalAdjustmentFactor = "historical_adjustment_factor"
    }
}
