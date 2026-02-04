import Fetch

/// A top-of-book quote with nanosecond precision.
///
/// Represents the best bid and ask prices from all major U.S. exchanges.
/// All timestamps are Unix nanoseconds in UTC.
///
/// ## CSV Columns
///
/// | Column | Type | Description |
/// |--------|------|-------------|
/// | ticker | string | Stock symbol |
/// | ask_exchange | integer | Ask exchange ID |
/// | ask_price | number | Ask price |
/// | ask_size | number | Ask size (shares) |
/// | bid_exchange | integer | Bid exchange ID |
/// | bid_price | number | Bid price |
/// | bid_size | number | Bid size (shares) |
/// | conditions | integer | Condition codes |
/// | indicators | integer | Indicator codes |
/// | participant_timestamp | integer | Exchange timestamp (nanos) |
/// | sequence_number | integer | Sequence for ordering |
/// | sip_timestamp | integer | SIP timestamp (nanos) |
/// | tape | integer | Tape (1=NYSE, 2=ARCA, 3=NASDAQ) |
/// | trf_timestamp | integer | TRF timestamp (nanos) |
public struct Quote: Sendable, Hashable {
    /// The stock ticker symbol.
    public let ticker: String

    /// The exchange ID posting the ask.
    public let askExchange: Int

    /// The ask (offer) price.
    public let askPrice: Double

    /// The size available at the ask price in shares.
    ///
    /// Note: Prior to November 3, 2025, this was in round lots (100 shares).
    public let askSize: Int

    /// The exchange ID posting the bid.
    public let bidExchange: Int

    /// The bid price.
    public let bidPrice: Double

    /// The size available at the bid price in shares.
    ///
    /// Note: Prior to November 3, 2025, this was in round lots (100 shares).
    public let bidSize: Int

    /// Condition codes for this quote.
    public let conditions: [Int]

    /// Indicator codes for this quote.
    public let indicators: [Int]

    /// The exchange/participant timestamp with nanosecond precision.
    public let participantTimestamp: Timestamp

    /// The sequence number for ordering quotes.
    public let sequenceNumber: Int

    /// The SIP (Securities Information Processor) timestamp.
    public let sipTimestamp: Timestamp

    /// The tape indicating the primary listing exchange.
    public let tape: Tape

    /// The TRF timestamp with nanosecond precision.
    public let trfTimestamp: Timestamp?

    /// Creates a quote from individual values.
    public init(
        ticker: String,
        askExchange: Int,
        askPrice: Double,
        askSize: Int,
        bidExchange: Int,
        bidPrice: Double,
        bidSize: Int,
        conditions: [Int],
        indicators: [Int],
        participantTimestamp: Timestamp,
        sequenceNumber: Int,
        sipTimestamp: Timestamp,
        tape: Tape,
        trfTimestamp: Timestamp? = nil
    ) {
        self.ticker = ticker
        self.askExchange = askExchange
        self.askPrice = askPrice
        self.askSize = askSize
        self.bidExchange = bidExchange
        self.bidPrice = bidPrice
        self.bidSize = bidSize
        self.conditions = conditions
        self.indicators = indicators
        self.participantTimestamp = participantTimestamp
        self.sequenceNumber = sequenceNumber
        self.sipTimestamp = sipTimestamp
        self.tape = tape
        self.trfTimestamp = trfTimestamp
    }
}
