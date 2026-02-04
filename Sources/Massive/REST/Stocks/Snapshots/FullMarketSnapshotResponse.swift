import Foundation

/// Response from the Full Market Snapshot endpoint.
public struct FullMarketSnapshotResponse: Codable, Sendable {
    /// The status of this request's response.
    public let status: String

    /// A request ID assigned by the server.
    public let requestId: String?

    /// The total number of results.
    public let count: Int?

    /// An array of snapshots for all tickers.
    public let tickers: [TickerSnapshot]?

    enum CodingKeys: String, CodingKey {
        case status
        case requestId = "request_id"
        case count
        case tickers
    }
}
