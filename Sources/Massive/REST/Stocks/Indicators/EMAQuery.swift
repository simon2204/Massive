import Fetch
import Foundation

/// Query parameters for the Exponential Moving Average (EMA) endpoint.
///
/// Get the exponential moving average (EMA) for a ticker symbol over a given time range.
/// EMA gives more weight to recent prices, making it more responsive to new information.
///
/// Use Cases: Trend following, crossover strategies, momentum analysis.
///
/// ## Example
/// ```swift
/// // 12-day EMA
/// let query = EMAQuery(ticker: "AAPL", window: 12)
///
/// // 26-day EMA for crossover strategy
/// let query = EMAQuery(
///     ticker: "AAPL",
///     window: 26,
///     timespan: .day,
///     seriesType: .close
/// )
/// ```
public struct EMAQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public let ticker: Ticker

    /// Query by timestamp.
    public var timestamp: Timestamp?

    /// The size of the aggregate time window.
    public var timespan: IndicatorTimespan?

    /// Whether or not the results are adjusted for splits. Default is true.
    public var adjusted: Bool?

    /// The window size used to calculate the EMA.
    public var window: Int?

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
        window: Int? = nil,
        seriesType: SeriesType? = nil,
        expandUnderlying: Bool? = nil,
        order: SortOrder? = nil,
        limit: Int? = nil
    ) {
        self.ticker = ticker
        self.timestamp = timestamp
        self.timespan = timespan
        self.adjusted = adjusted
        self.window = window
        self.seriesType = seriesType
        self.expandUnderlying = expandUnderlying
        self.order = order
        self.limit = limit
    }

    public var path: String {
        "/v1/indicators/ema/\(ticker.symbol)"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("timestamp", timestamp)
        builder.add("timespan", timespan)
        builder.add("adjusted", adjusted)
        builder.add("window", window)
        builder.add("series_type", seriesType)
        builder.add("expand_underlying", expandUnderlying)
        builder.add("order", order)
        builder.add("limit", limit)
        return builder.build()
    }
}
