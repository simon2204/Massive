import Foundation

/// Query parameters for the Custom Bars (OHLC) endpoint.
///
/// Retrieve aggregated historical OHLC (Open, High, Low, Close) and volume data
/// for a specified stock ticker over a custom date range and time interval in Eastern Time (ET).
///
/// Aggregates are constructed exclusively from qualifying trades that meet specific conditions.
/// If no eligible trades occur within a given timeframe, no aggregate bar is produced,
/// resulting in an empty interval that indicates a lack of trading activity during that period.
///
/// Use Cases: Data visualization, technical analysis, backtesting strategies, market research.
///
/// ## Example
/// ```swift
/// // 1-day bars for AAPL
/// let query = BarsQuery(ticker: "AAPL", from: "2024-01-01", to: "2024-01-31")
///
/// // 5-minute bars
/// let query = BarsQuery(
///     ticker: "AAPL",
///     multiplier: 5,
///     timespan: .minute,
///     from: "2024-01-15",
///     to: "2024-01-15"
/// )
/// ```
public struct BarsQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    /// The size of the timespan multiplier (e.g., 5 for 5-minute bars).
    public let multiplier: Int

    /// The size of the time window.
    public let timespan: Timespan

    /// The start of the aggregate time window.
    /// Either a date with format `YYYY-MM-DD` or a millisecond timestamp.
    public let from: String

    /// The end of the aggregate time window.
    /// Either a date with format `YYYY-MM-DD` or a millisecond timestamp.
    public let to: String

    /// Whether or not the results are adjusted for splits.
    /// By default, results are adjusted. Set to `false` to get unadjusted results.
    public let adjusted: Bool?

    /// Sort the results by timestamp.
    public let sort: SortOrder?

    /// Limits the number of base aggregates queried to create the aggregate results.
    /// Max 50000, default 5000.
    public let limit: Int?

    /// The size of the time window for aggregation.
    public enum Timespan: String, Sendable, CaseIterable {
        case second
        case minute
        case hour
        case day
        case week
        case month
        case quarter
        case year
    }

    public init(
        ticker: Ticker,
        multiplier: Int = 1,
        timespan: Timespan = .day,
        from: String,
        to: String,
        adjusted: Bool? = nil,
        sort: SortOrder? = nil,
        limit: Int? = nil
    ) {
        self.ticker = ticker
        self.multiplier = multiplier
        self.timespan = timespan
        self.from = from
        self.to = to
        self.adjusted = adjusted
        self.sort = sort
        self.limit = limit
    }

    public var path: String {
        "/v2/aggs/ticker/\(ticker.symbol)/range/\(multiplier)/\(timespan.rawValue)/\(from)/\(to)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("adjusted", adjusted)
        builder.add("sort", sort)
        builder.add("limit", limit)
        return builder.build()
    }
}
