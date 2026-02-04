import Fetch

/// A single trade execution with nanosecond precision.
///
/// Represents tick-level data from all major U.S. exchanges and dark pools.
/// All timestamps are Unix nanoseconds in UTC.
///
/// ## CSV Columns
///
/// | Column | Type | Description |
/// |--------|------|-------------|
/// | ticker | string | Stock symbol |
/// | conditions | integer | Condition codes (comma-separated if multiple) |
/// | correction | integer | Trade correction indicator |
/// | exchange | integer | Exchange ID |
/// | id | string | Unique trade ID |
/// | participant_timestamp | integer | Exchange timestamp (nanos) |
/// | price | number | Trade price per share |
/// | sequence_number | integer | Sequence for ordering |
/// | sip_timestamp | integer | SIP timestamp (nanos) |
/// | size | number | Trade size (shares) |
/// | tape | integer | Tape (1=NYSE, 2=ARCA, 3=NASDAQ) |
/// | trf_id | integer | Trade Reporting Facility ID |
/// | trf_timestamp | integer | TRF timestamp (nanos) |
public struct Trade: Sendable, Hashable {
    /// The stock ticker symbol.
    public let ticker: String

    /// Condition codes for this trade.
    ///
    /// Multiple conditions are represented as an array.
    public let conditions: [Int]

    /// The trade correction indicator.
    ///
    /// - 0: Regular trade
    /// - 1-n: Correction sequence
    public let correction: Int

    /// The exchange ID where the trade occurred.
    public let exchange: Int

    /// The unique trade identifier.
    public let id: String

    /// The exchange/participant timestamp with nanosecond precision.
    public let participantTimestamp: Timestamp

    /// The trade price per share (unadjusted).
    public let price: Double

    /// The sequence number for ordering trades.
    public let sequenceNumber: Int

    /// The SIP (Securities Information Processor) timestamp.
    public let sipTimestamp: Timestamp

    /// The trade size in shares.
    public let size: Int

    /// The tape identifier.
    ///
    /// - 1: NYSE listed
    /// - 2: NYSE ARCA/American listed
    /// - 3: NASDAQ listed
    public let tape: Int

    /// The Trade Reporting Facility ID (for off-exchange trades).
    public let trfId: Int?

    /// The TRF timestamp with nanosecond precision.
    public let trfTimestamp: Timestamp?

    /// Creates a trade from individual values.
    public init(
        ticker: String,
        conditions: [Int],
        correction: Int,
        exchange: Int,
        id: String,
        participantTimestamp: Timestamp,
        price: Double,
        sequenceNumber: Int,
        sipTimestamp: Timestamp,
        size: Int,
        tape: Int,
        trfId: Int? = nil,
        trfTimestamp: Timestamp? = nil
    ) {
        self.ticker = ticker
        self.conditions = conditions
        self.correction = correction
        self.exchange = exchange
        self.id = id
        self.participantTimestamp = participantTimestamp
        self.price = price
        self.sequenceNumber = sequenceNumber
        self.sipTimestamp = sipTimestamp
        self.size = size
        self.tape = tape
        self.trfId = trfId
        self.trfTimestamp = trfTimestamp
    }
}
