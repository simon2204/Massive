import Foundation

/// Response from the Single Ticker Snapshot endpoint.
public struct SingleTickerSnapshotResponse: Codable, Sendable {
    /// The status of this request's response.
    public let status: String

    /// A request ID assigned by the server.
    public let requestId: String

    /// The snapshot data for the requested ticker.
    public let ticker: TickerSnapshot?

    enum CodingKeys: String, CodingKey {
        case status
        case requestId = "request_id"
        case ticker
    }
}
