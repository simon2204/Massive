import Fetch

/// Protocol for aggregate OHLCV data (minute or day bars).
///
/// Both `MinuteAggregate` and `DayAggregate` conform to this protocol,
/// enabling generic parsing in `FlatFileParser`.
public protocol AggregateData: Sendable, Hashable {
    /// The stock ticker symbol.
    var ticker: String { get }

    /// The trading volume during this period.
    var volume: Int { get }

    /// The opening price.
    var open: Double { get }

    /// The closing price.
    var close: Double { get }

    /// The highest price during this period.
    var high: Double { get }

    /// The lowest price during this period.
    var low: Double { get }

    /// The start of the time window as a precise timestamp.
    var windowStart: Timestamp { get }

    /// The number of transactions during this period.
    var transactions: Int { get }

    /// Creates an aggregate from individual values.
    init(
        ticker: String,
        volume: Int,
        open: Double,
        close: Double,
        high: Double,
        low: Double,
        windowStart: Timestamp,
        transactions: Int
    )
}
