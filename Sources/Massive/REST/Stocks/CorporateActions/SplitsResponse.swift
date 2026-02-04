import Foundation

/// Response from the Stock Splits endpoint.
public struct SplitsResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of stock splits.
    public let results: [StockSplit]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// A stock split event.
public struct StockSplit: Codable, Sendable {
    /// Unique identifier for this split event.
    public let id: String?

    /// The ticker symbol.
    public let ticker: String?

    /// Date the split was executed.
    public let executionDate: String?

    /// Type of adjustment (forward_split, reverse_split, stock_dividend).
    public let adjustmentType: String?

    /// Original shares (denominator).
    public let splitFrom: Double?

    /// New shares (numerator).
    public let splitTo: Double?

    /// Cumulative adjustment factor for historical prices.
    public let historicalAdjustmentFactor: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case ticker
        case executionDate = "execution_date"
        case adjustmentType = "adjustment_type"
        case splitFrom = "split_from"
        case splitTo = "split_to"
        case historicalAdjustmentFactor = "historical_adjustment_factor"
    }
}
