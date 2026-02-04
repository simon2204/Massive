import Foundation

/// Response from the Previous Day Bar endpoint.
public struct PreviousDayBarResponse: Codable, Sendable {
    /// The exchange symbol that this item is traded under.
    public let ticker: Ticker

    /// Whether or not this response was adjusted for splits.
    public let adjusted: Bool

    /// The number of aggregates used to generate the response.
    public let queryCount: Int

    /// A request ID assigned by the server.
    public let requestId: String

    /// The total number of results for this request.
    public let resultsCount: Int

    /// The status of this request's response.
    public let status: String

    /// An array containing the previous day's bar (typically one result).
    public let results: [Bar]?
}
