import Foundation

/// Query parameters for the Full Market Snapshot endpoint.
///
/// Get the most up-to-date market data for all traded stock tickers.
///
/// Use Cases: Market-wide screening, real-time dashboards, scanning for opportunities.
///
/// ## Example
/// ```swift
/// let query = FullMarketSnapshotQuery()
/// let snapshots = try await client.marketSnapshot(query)
/// for ticker in snapshots.tickers ?? [] {
///     print("\(ticker.ticker ?? ""): \(ticker.todaysChangePerc ?? 0)%")
/// }
/// ```
public struct FullMarketSnapshotQuery: APIQuery {
    /// Filter to tickers that contain this search string.
    public var tickers: [Ticker]?

    /// Include OTC securities.
    public var includeOtc: Bool?

    public init(tickers: [Ticker]? = nil, includeOtc: Bool? = nil) {
        self.tickers = tickers
        self.includeOtc = includeOtc
    }

    public var path: String {
        "/v2/snapshot/locale/us/markets/stocks/tickers"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        if let tickers = tickers, !tickers.isEmpty {
            builder.add("tickers", tickers.map(\.symbol).joined(separator: ","))
        }
        builder.add("include_otc", includeOtc)
        return builder.build()
    }
}
