import Foundation

/// Query parameters for the Market Status endpoint.
///
/// Get the current trading status of supported exchanges.
///
/// Use Cases: Real-time market monitoring, trading system integration, status dashboards.
///
/// ## Example
/// ```swift
/// let status = try await client.marketStatus(MarketStatusQuery())
/// print("Market: \(status.market ?? "unknown")")
/// print("NYSE: \(status.exchanges?.nyse ?? "unknown")")
/// ```
public struct MarketStatusQuery: APIQuery {
    public init() {}

    public var path: String {
        "/v1/marketstatus/now"
    }

    public var queryItems: [URLQueryItem]? {
        nil
    }
}
