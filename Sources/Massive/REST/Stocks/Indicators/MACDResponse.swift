import Foundation

/// Response from the Moving Average Convergence/Divergence (MACD) endpoint.
public struct MACDResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The MACD calculation results.
    public let results: MACDResults?

    /// URL for fetching the next page of data.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}
