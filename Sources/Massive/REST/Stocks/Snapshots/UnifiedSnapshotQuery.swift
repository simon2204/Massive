import Foundation

/// Query parameters for the Universal Snapshot endpoint.
///
/// Get snapshots for assets of all types. Supports stocks, options, indices, forex, and crypto.
///
/// Use Cases: Cross-asset monitoring, unified portfolio views, multi-market analysis.
///
/// ## Example
/// ```swift
/// let query = UnifiedSnapshotQuery(tickers: ["AAPL", "O:AAPL230616C00150000", "X:BTCUSD"])
/// let snapshots = try await client.universalSnapshot(query)
/// for result in snapshots.results ?? [] {
///     print("\(result.ticker ?? ""): \(result.lastTrade?.p ?? 0)")
/// }
/// ```
public struct UnifiedSnapshotQuery: APIQuery {
    /// Comma-separated list of tickers (stocks, options, indices, forex, crypto).
    public let tickers: [String]

    public init(tickers: [String]) {
        self.tickers = tickers
    }

    public var path: String {
        "/v3/snapshot"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker.any_of", tickers.joined(separator: ","))
        return builder.build()
    }
}
