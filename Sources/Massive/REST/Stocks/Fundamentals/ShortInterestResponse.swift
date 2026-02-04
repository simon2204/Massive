import Foundation

/// Response from the Short Interest endpoint.
public struct ShortInterestResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of short interest records.
    public let results: [ShortInterest]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// Short interest data for a ticker.
public struct ShortInterest: Codable, Sendable {
    /// The ticker symbol.
    public let ticker: String?

    /// Settlement date for the short interest data.
    public let settlementDate: String?

    /// Number of shares sold short.
    public let shortInterest: Int?

    /// Average daily trading volume.
    public let avgDailyVolume: Int?

    /// Days to cover (short interest / avg daily volume).
    public let daysToCover: Double?

    enum CodingKeys: String, CodingKey {
        case ticker
        case settlementDate = "settlement_date"
        case shortInterest = "short_interest"
        case avgDailyVolume = "avg_daily_volume"
        case daysToCover = "days_to_cover"
    }
}
