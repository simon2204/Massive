import Foundation

/// Response from the Exchanges endpoint.
public struct ExchangesResponse: Codable, Sendable {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The total number of results.
    public let count: Int?

    /// The list of exchanges.
    public let results: [Exchange]?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case count
        case results
    }
}

/// Information about a stock exchange.
public struct Exchange: Codable, Sendable {
    /// Unique Massive identifier for the exchange.
    public let id: Int

    /// Name of the exchange.
    public let name: String

    /// A commonly used abbreviation for this exchange.
    public let acronym: String?

    /// The asset class this exchange trades.
    public let assetClass: String

    /// The locale of this exchange.
    public let locale: String

    /// The Market Identifier Code (ISO 10383).
    public let mic: String?

    /// The MIC of the entity that operates this exchange.
    public let operatingMic: String?

    /// The ID used by SIPs to represent this exchange.
    public let participantId: String?

    /// The type of exchange.
    public let type: ExchangeType

    /// A link to this exchange's website.
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case acronym
        case assetClass = "asset_class"
        case locale
        case mic
        case operatingMic = "operating_mic"
        case participantId = "participant_id"
        case type
        case url
    }
}
