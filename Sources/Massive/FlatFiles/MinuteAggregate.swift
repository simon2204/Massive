import Fetch

/// A one-minute OHLCV candlestick.
///
/// Represents aggregated market data for a single minute period.
/// Data is unadjusted (no split or dividend adjustments).
///
/// ## CSV Columns
///
/// | Column | Type | Description |
/// |--------|------|-------------|
/// | ticker | string | Stock symbol |
/// | volume | number | Total volume |
/// | open | number | Opening price |
/// | close | number | Closing price |
/// | high | number | Highest price |
/// | low | number | Lowest price |
/// | window_start | integer | Unix nanosecond timestamp |
/// | transactions | integer | Number of trades |
public struct MinuteAggregate: Sendable, Hashable {
    /// The stock ticker symbol.
    public let ticker: String

    /// The trading volume during this minute.
    public let volume: Int

    /// The opening price.
    public let open: Double

    /// The closing price.
    public let close: Double

    /// The highest price during this minute.
    public let high: Double

    /// The lowest price during this minute.
    public let low: Double

    /// The start of the minute window as a precise timestamp.
    public let windowStart: Timestamp

    /// The number of transactions during this minute.
    public let transactions: Int

    /// Creates a minute aggregate from individual values.
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
