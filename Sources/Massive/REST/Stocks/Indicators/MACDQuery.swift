import Fetch
import Foundation

/// Query parameters for the Moving Average Convergence/Divergence (MACD) endpoint.
///
/// Get the MACD for a ticker symbol over a given time range.
/// MACD shows the relationship between two EMAs and includes a signal line.
///
/// Use Cases: Trend direction, momentum, signal line crossovers, divergence analysis.
///
/// ## Example
/// ```swift
/// // Standard MACD (12, 26, 9)
/// let query = MACDQuery(ticker: "AAPL")
///
/// // Custom MACD settings
/// let query = MACDQuery(
///     ticker: "AAPL",
///     shortWindow: 12,
///     longWindow: 26,
///     signalWindow: 9,
///     timespan: .day
/// )
/// ```
public struct MACDQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    /// Query by timestamp.
    public var timestamp: Timestamp?

    /// The size of the aggregate time window.
    public var timespan: IndicatorTimespan?

    /// Whether or not the results are adjusted for splits. Default is true.
    public var adjusted: Bool?

    /// The short window size for MACD calculation.
    public var shortWindow: Int?

    /// The long window size for MACD calculation.
    public var longWindow: Int?

    /// The signal window size for MACD signal line calculation.
    public var signalWindow: Int?

    /// The price component to use for calculation.
    public var seriesType: SeriesType?

    /// Include the aggregates used to calculate the indicator.
    public var expandUnderlying: Bool?

    /// Order results by timestamp.
    public var order: SortOrder?

    /// Limit the number of results (default 10, max 5000).
    public var limit: Int?

    public init(
        ticker: Ticker,
        timestamp: Timestamp? = nil,
        timespan: IndicatorTimespan? = nil,
        adjusted: Bool? = nil,
        shortWindow: Int? = nil,
        longWindow: Int? = nil,
        signalWindow: Int? = nil,
        seriesType: SeriesType? = nil,
        expandUnderlying: Bool? = nil,
        order: SortOrder? = nil,
        limit: Int? = nil
    ) {
        self.ticker = ticker
        self.timestamp = timestamp
        self.timespan = timespan
        self.adjusted = adjusted
        self.shortWindow = shortWindow
        self.longWindow = longWindow
        self.signalWindow = signalWindow
        self.seriesType = seriesType
        self.expandUnderlying = expandUnderlying
        self.order = order
        self.limit = limit
    }

    public var path: String {
        "/v1/indicators/macd/\(ticker.symbol)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("timestamp", timestamp)
        builder.add("timespan", timespan)
        builder.add("adjusted", adjusted)
        builder.add("short_window", shortWindow)
        builder.add("long_window", longWindow)
        builder.add("signal_window", signalWindow)
        builder.add("series_type", seriesType)
        builder.add("expand_underlying", expandUnderlying)
        builder.add("order", order)
        builder.add("limit", limit)
        return builder.build()
    }
}
