import Foundation

/// The size of the time window for indicator calculations.
public enum IndicatorTimespan: String, Sendable, CaseIterable {
    case second
    case minute
    case hour
    case day
    case week
    case month
    case quarter
    case year
}

/// The price component used for indicator calculations.
public enum SeriesType: String, Sendable, CaseIterable {
    case close
    case open
    case high
    case low
}

/// A single indicator value at a point in time.
public struct IndicatorValue: Codable, Sendable {
    /// The Unix millisecond timestamp.
    public let timestamp: Int?

    /// The indicator value at this timestamp.
    public let value: Double?
}

/// A single MACD value at a point in time.
public struct MACDValue: Codable, Sendable {
    /// The Unix millisecond timestamp.
    public let timestamp: Int?

    /// The MACD line value.
    public let value: Double?

    /// The signal line value.
    public let signal: Double?

    /// The histogram value (MACD - Signal).
    public let histogram: Double?
}

/// Underlying aggregate data used in indicator calculations.
public struct IndicatorUnderlying: Codable, Sendable {
    /// The URL for fetching the underlying aggregates.
    public let url: String?

    /// The aggregate bars used in the calculation.
    public let aggregates: [IndicatorAggregate]?
}

/// An aggregate bar within indicator underlying data.
public struct IndicatorAggregate: Codable, Sendable {
    /// The close price.
    public let c: Double?

    /// The highest price.
    public let h: Double?

    /// The lowest price.
    public let l: Double?

    /// The number of transactions.
    public let n: Int?

    /// The open price.
    public let o: Double?

    /// Whether this is for an OTC ticker.
    public let otc: Bool?

    /// The Unix millisecond timestamp.
    public let t: Int?

    /// The trading volume.
    public let v: Double?

    /// The volume weighted average price.
    public let vw: Double?
}

/// Results container for simple indicators (SMA, EMA, RSI).
public struct IndicatorResults: Codable, Sendable {
    /// The underlying aggregate data (when expand_underlying is true).
    public let underlying: IndicatorUnderlying?

    /// The calculated indicator values.
    public let values: [IndicatorValue]?
}

/// Results container for MACD indicator.
public struct MACDResults: Codable, Sendable {
    /// The underlying aggregate data (when expand_underlying is true).
    public let underlying: IndicatorUnderlying?

    /// The calculated MACD values.
    public let values: [MACDValue]?
}
