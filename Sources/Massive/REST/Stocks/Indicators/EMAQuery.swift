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
public struct EMAQuery: BaseIndicatorQuery {
    public static let indicatorName = "ema"

    public let ticker: Ticker
    public let timestamp: Timestamp?
    public let timespan: IndicatorTimespan?
    public let adjusted: Bool?
    public let window: Int?
    public let seriesType: SeriesType?
    public let expandUnderlying: Bool?
    public let order: SortOrder?
    public let limit: Int?

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
