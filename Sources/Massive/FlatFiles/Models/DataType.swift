/// The type of market data in a flat file.
public enum DataType: String, Sendable, CaseIterable {
    /// Individual trade executions with nanosecond timestamps.
    ///
    /// Contains price, volume, exchange, and condition codes for each trade.
    case trades = "trades_v1"

    /// Top-of-book quotes with nanosecond timestamps.
    ///
    /// Contains bid/ask prices and sizes from all exchanges.
    case quotes = "quotes_v1"

    /// One-minute OHLCV candlesticks.
    ///
    /// Aggregated open, high, low, close prices and volume per minute.
    case minuteAggregates = "minute_aggs_v1"

    /// Daily OHLCV candlesticks.
    ///
    /// Aggregated open, high, low, close prices and volume per day.
    case dayAggregates = "day_aggs_v1"
}
