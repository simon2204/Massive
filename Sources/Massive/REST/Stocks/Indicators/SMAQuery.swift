import Fetch
import Foundation

/// Query parameters for the Simple Moving Average (SMA) endpoint.
///
/// Get the simple moving average (SMA) for a ticker symbol over a given time range.
///
/// Use Cases: Trend identification, support/resistance levels, smoothing price data.
///
/// ## Example
/// ```swift
/// // 20-day SMA
/// let query = SMAQuery(ticker: "AAPL", window: 20)
///
/// // 50-day SMA with specific timestamp
/// let query = SMAQuery(
///     ticker: "AAPL",
///     window: 50,
///     timespan: .day,
///     timestamp: .now
/// )
/// ```
public struct SMAQuery: BaseIndicatorQuery {
    public static let indicatorName = "sma"

    public let ticker: Ticker
    public var timestamp: Timestamp?
    public var timespan: IndicatorTimespan?
    public var adjusted: Bool?
    public var window: Int?
    public var seriesType: SeriesType?
    public var expandUnderlying: Bool?
    public var order: SortOrder?
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
}
