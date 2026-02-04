import Foundation

/// Query parameters for the Single Ticker Snapshot endpoint.
///
/// Get the most up-to-date market data for a single traded stock ticker.
///
/// Use Cases: Real-time price monitoring, quick lookups, trading dashboards.
///
/// ## Example
/// ```swift
/// let query = SingleTickerSnapshotQuery(ticker: "AAPL")
/// let snapshot = try await client.tickerSnapshot(query)
/// print("Current price: \(snapshot.ticker?.lastTrade?.p ?? 0)")
/// ```
public struct SingleTickerSnapshotQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    public init(ticker: Ticker) {
        self.ticker = ticker
    }

    public var path: String {
        "/v2/snapshot/locale/us/markets/stocks/tickers/\(ticker.symbol)"
    }

    public var queryItems: [URLQueryItem]? {
        nil
    }
}
