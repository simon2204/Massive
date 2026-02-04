import Fetch
import Foundation

/// Common parameters shared by all technical indicator queries (SMA, EMA, RSI, etc.).
///
/// This protocol reduces code duplication by providing a default implementation
/// for `queryItems` that handles the standard indicator parameters.
public protocol BaseIndicatorQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    var ticker: Ticker { get }

    /// Query by timestamp.
    var timestamp: Timestamp? { get }

    /// The size of the aggregate time window.
    var timespan: IndicatorTimespan? { get }

    /// Whether or not the results are adjusted for splits. Default is true.
    var adjusted: Bool? { get }

    /// The window size used to calculate the indicator.
    var window: Int? { get }

    /// The price component to use for calculation.
    var seriesType: SeriesType? { get }

    /// Include the aggregates used to calculate the indicator.
    var expandUnderlying: Bool? { get }

    /// Order results by timestamp.
    var order: SortOrder? { get }

    /// Limit the number of results (default 10, max 5000).
    var limit: Int? { get }

    /// The indicator name used in the API path (e.g., "sma", "ema", "rsi").
    static var indicatorName: String { get }
}

extension BaseIndicatorQuery {
    public var path: String {
        "/v1/indicators/\(Self.indicatorName)/\(ticker.symbol)"
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
