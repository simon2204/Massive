import Foundation

/// Response from the Relative Strength Index (RSI) endpoint.
public struct RSIResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The RSI calculation results.
    public let results: IndicatorResults?

    /// URL for fetching the next page of data.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}
