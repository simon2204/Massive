import Foundation

/// Response from the Tickers endpoint.
public struct TickersResponse: Codable, PaginatedResponse {
    /// The total number of results for this request.
    public let count: Int?
    /// If present, this value can be used to fetch the next page of data.
    public let nextUrl: String?

    /// A request ID assigned by the server.
    public let requestId: String?

    /// An array of tickers that match your query.
    public let results: [TickerListItem]?

    /// The status of this request's response.
    public let status: String?
}

/// A ticker item from the Tickers endpoint.
public struct TickerListItem: Codable, Sendable {
    /// The name of the asset.
    public let name: String

    /// The exchange symbol that this item is traded under.
    public let ticker: Ticker

    /// Whether or not the asset is actively traded.
    public let active: Bool?

    /// The name of the currency that this asset is priced against (for crypto/fx).
    public let baseCurrencyName: String?

    /// The ISO 4217 code of the currency that this asset is priced against.
    public let baseCurrencySymbol: String?

    /// The CIK number for this ticker.
    public let cik: String?

    /// The composite OpenFIGI number for this ticker.
    public let compositeFigi: String?

    /// The name of the currency that this asset is traded with.
    public let currencyName: String?

    /// The ISO 4217 code of the currency that this asset is traded with.
    public let currencySymbol: String?

    /// The last date that the asset was traded.
    public let delistedUtc: String?

    /// The information is accurate up to this time.
    public let lastUpdatedUtc: String?

    /// The locale of the asset.
    public let locale: TickerLocale?

    /// The market type of the asset.
    public let market: TickerMarket?

    /// The ISO code of the primary listing exchange for this asset.
    public let primaryExchange: String?

    /// The share Class OpenFIGI number for this ticker.
    public let shareClassFigi: String?

    /// The type of the asset.
    public let type: String?
}

