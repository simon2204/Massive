import Fetch
import Foundation

/// Query parameters for the Relative Strength Index (RSI) endpoint.
///
/// Get the RSI for a ticker symbol over a given time range.
/// RSI measures the speed and magnitude of price movements on a scale of 0-100.
///
/// Use Cases: Overbought/oversold conditions, divergence analysis, trend confirmation.
///
/// ## Example
/// ```swift
/// // Standard 14-period RSI
/// let query = RSIQuery(ticker: "AAPL", window: 14)
///
/// // RSI with specific settings
/// let query = RSIQuery(
///     ticker: "AAPL",
///     window: 14,
///     timespan: .day,
///     seriesType: .close
/// )
/// ```
public struct RSIQuery: BaseIndicatorQuery {
    public static let indicatorName = "rsi"

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
