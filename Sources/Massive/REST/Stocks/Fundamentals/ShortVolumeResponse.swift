import Foundation

/// Response from the Short Volume endpoint.
public struct ShortVolumeResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of short volume records.
    public let results: [ShortVolume]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// Daily short volume data for a ticker.
public struct ShortVolume: Codable, Sendable {
    /// The ticker symbol.
    public let ticker: String?

    /// The trade date.
    public let date: String?

    /// Total short volume.
    public let shortVolume: Int?

    /// Total trading volume.
    public let totalVolume: Int?

    /// Short volume as percentage of total volume.
    public let shortVolumeRatio: Double?

    enum CodingKeys: String, CodingKey {
        case ticker, date
        case shortVolume = "short_volume"
        case totalVolume = "total_volume"
        case shortVolumeRatio = "short_volume_ratio"
    }
}
