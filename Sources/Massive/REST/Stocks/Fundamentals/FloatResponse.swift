import Foundation

/// Response from the Float endpoint.
public struct FloatResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of float records.
    public let results: [StockFloat]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// Float data for a ticker.
public struct StockFloat: Codable, Sendable {
    /// The ticker symbol.
    public let ticker: String?

    /// Effective date for the float data.
    public let effectiveDate: String?

    /// Number of shares freely tradable.
    public let freeFloat: Int?

    /// Percentage of shares freely tradable.
    public let freeFloatPercent: Double?

    enum CodingKeys: String, CodingKey {
        case ticker
        case effectiveDate = "effective_date"
        case freeFloat = "free_float"
        case freeFloatPercent = "free_float_percent"
    }
}
