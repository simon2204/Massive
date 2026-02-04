import Foundation

/// Query parameters for the Ticker Events endpoint.
///
/// Get a timeline of significant events for a ticker, including symbol changes and rebranding.
///
/// Use Cases: Historical ticker tracking, symbol change history, corporate event timeline.
///
/// ## Example
/// ```swift
/// // All events for META (formerly FB)
/// let query = TickerEventsQuery(id: "META")
///
/// // Only ticker change events
/// let query = TickerEventsQuery(id: "META", types: "ticker_change")
/// ```
public struct TickerEventsQuery: APIQuery {
    /// Identifier for the asset (ticker symbol, CUSIP, or Composite FIGI).
    public let id: String

    /// Comma-separated list of event types to include.
    /// Currently supported: "ticker_change"
    public let types: String?

    public init(id: String, types: String? = nil) {
        self.id = id
        self.types = types
    }

    public var path: String {
        "/vX/reference/tickers/\(id)/events"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("types", types)
        return builder.build()
    }
}
