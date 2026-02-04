import Foundation

/// Response from the Market Status endpoint.
public struct MarketStatusResponse: Codable, Sendable {
    /// Overall market status.
    public let market: String?

    /// Current server time in RFC3339 format.
    public let serverTime: String?

    /// Status of major exchanges.
    public let exchanges: ExchangeStatuses?

    /// Status of currency markets.
    public let currencies: CurrencyStatuses?

    /// Whether pre-market trading is active.
    public let earlyHours: Bool?

    /// Whether after-hours trading is active.
    public let afterHours: Bool?

    /// Status of various index groups.
    public let indicesGroups: IndicesGroupStatuses?
}

/// Status of major stock exchanges.
public struct ExchangeStatuses: Codable, Sendable {
    /// NYSE market status.
    public let nyse: String?

    /// Nasdaq market status.
    public let nasdaq: String?

    /// OTC market status.
    public let otc: String?
}

/// Status of currency markets.
public struct CurrencyStatuses: Codable, Sendable {
    /// Cryptocurrency market status.
    public let crypto: String?

    /// Forex market status.
    public let fx: String?
}

/// Status of index groups.
public struct IndicesGroupStatuses: Codable, Sendable {
    /// S&P indices status.
    public let sp: String?

    /// Dow Jones indices status.
    public let dowJones: String?

    /// Nasdaq indices status.
    public let nasdaq: String?

    /// FTSE Russell indices status.
    public let ftseRussell: String?

    /// MSCI indices status.
    public let msci: String?

    /// Morningstar indices status.
    public let mstar: String?

    /// Cboe indices status.
    public let cboe: String?

    enum CodingKeys: String, CodingKey {
        case sp = "s_and_p"
        case dowJones = "dow_jones"
        case nasdaq
        case ftseRussell = "ftse_russell"
        case msci
        case mstar
        case cboe
    }
}
