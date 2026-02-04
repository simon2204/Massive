import Foundation

/// Net Order Imbalance (NOI) data from WebSocket stream.
public struct StreamImbalance: Sendable, Decodable {
    /// The event type (`NOI`).
    public let eventType: String

    /// The ticker symbol.
    public let symbol: String

    /// The timestamp in Unix milliseconds.
    public let timestamp: Int64

    /// The planned auction time in EST format: (hour × 100) + minutes.
    /// For example, 930 = 9:30 AM.
    public let auctionTime: Int

    /// The auction type.
    public let auctionType: AuctionType

    /// The symbol sequence number.
    public let sequenceNumber: Int

    /// The exchange ID.
    public let exchange: Int

    /// The imbalance quantity.
    public let imbalanceQuantity: Int

    /// The paired quantity.
    public let pairedQuantity: Int

    /// The book clearing price.
    public let bookClearingPrice: Double

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case symbol = "T"
        case timestamp = "t"
        case auctionTime = "at"
        case auctionType = "a"
        case sequenceNumber = "i"
        case exchange = "x"
        case imbalanceQuantity = "o"
        case pairedQuantity = "p"
        case bookClearingPrice = "b"
    }
}

/// The type of auction for an imbalance event.
public enum AuctionType: String, Sendable, Decodable {
    /// Early Opening Auction
    case earlyOpening = "O"
    /// Core Opening Auction
    case coreOpening = "M"
    /// Halt Resume Auction
    case haltResume = "H"
    /// Closing Auction
    case closing = "C"
    /// Extreme Closing Imbalance (NYSE only)
    case extremeClosing = "P"
    /// Regulatory Closing Imbalance (NYSE only)
    case regulatoryClosing = "R"
}
