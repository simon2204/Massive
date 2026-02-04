import Foundation

/// Response from the Top Market Movers endpoint.
public struct TopMoversResponse: Codable, Sendable {
    /// The status of this request's response.
    public let status: String

    /// A request ID assigned by the server.
    public let requestId: String?

    /// An array of the top movers (gainers or losers).
    public let tickers: [TickerSnapshot]?

    enum CodingKeys: String, CodingKey {
        case status
        case requestId = "request_id"
        case tickers
    }
}
