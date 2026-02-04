import Foundation
import Fetch

/// A daily OHLCV candlestick.
///
/// Represents aggregated market data for a single trading day.
/// Data is unadjusted (no split or dividend adjustments).
public struct DayAggregate: AggregateData {
    /// The stock ticker symbol.
    public let ticker: String

    /// The trading volume for the day.
    public let volume: Int

    /// The opening price.
    public let open: Double

    /// The closing price.
    public let close: Double

    /// The highest price during the day.
    public let high: Double

    /// The lowest price during the day.
    public let low: Double

    /// The start of the trading day as a precise timestamp.
    public let windowStart: Timestamp

    /// The number of transactions during the day.
    public let transactions: Int

    /// Creates a day aggregate from individual values.
    public init(
        ticker: String,
        volume: Int,
        open: Double,
        close: Double,
        high: Double,
        low: Double,
        windowStart: Timestamp,
        transactions: Int
    ) {
        self.ticker = ticker
        self.volume = volume
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.windowStart = windowStart
        self.transactions = transactions
    }
}
