import Foundation

/// Response from the Ticker Overview endpoint.
public struct TickerOverviewResponse: Codable, Sendable {
    /// The total number of results for this request.
    public let count: Int?

    /// A request ID assigned by the server.
    public let requestId: String?

    /// The ticker details.
    public let results: TickerDetails?

    /// The status of this request's response.
    public let status: String?
}

/// Comprehensive details about a ticker.
public struct TickerDetails: Codable, Sendable {
    /// Whether the asset is actively traded. False indicates delisting.
    public let active: Bool

    /// The name of the currency that this asset is traded with.
    public let currencyName: String

    /// The locale of the asset.
    public let locale: TickerLocale

    /// The market type of the asset.
    public let market: TickerMarket

    /// The name of the asset.
    public let name: String

    /// The exchange symbol that this item is traded under.
    public let ticker: Ticker

    /// Company headquarters address details.
    public let address: TickerAddress?

    /// Provides URLs aiding in visual identification.
    public let branding: TickerBranding?

    /// The CIK number for this ticker.
    public let cik: String?

    /// The composite OpenFIGI number for this ticker.
    public let compositeFigi: String?

    /// The last date that the asset was traded.
    public let delistedUtc: String?

    /// A description of the company and what they do/offer.
    public let description: String?

    /// The URL of the company's website homepage.
    public let homepageUrl: String?

    /// The date that the symbol was first publicly listed (YYYY-MM-DD format).
    public let listDate: String?

    /// The most recent close price multiplied by weighted outstanding shares.
    public let marketCap: Double?

    /// The phone number for the company behind this ticker.
    public let phoneNumber: String?

    /// The ISO code of the primary listing exchange.
    public let primaryExchange: String?

    /// Round lot size of this security.
    public let roundLot: Int?

    /// The share Class OpenFIGI number for this ticker.
    public let shareClassFigi: String?

    /// The recorded number of outstanding shares for this share class.
    public let shareClassSharesOutstanding: Int?

    /// The standard industrial classification code for this ticker.
    public let sicCode: String?

    /// A description of this ticker's SIC code.
    public let sicDescription: String?

    /// The root of a specified ticker (e.g., "BRK" for "BRK.A").
    public let tickerRoot: String?

    /// The suffix of a specified ticker (e.g., "A" for "BRK.A").
    public let tickerSuffix: String?

    /// The approximate number of employees for the company.
    public let totalEmployees: Int?

    /// The type of the asset.
    public let type: String?

    /// Shares outstanding assuming conversion of all other share classes.
    public let weightedSharesOutstanding: Int?
}

/// Company headquarters address.
public struct TickerAddress: Codable, Sendable {
    /// The first line of the address.
    public let address1: String?

    /// The city of the address.
    public let city: String?

    /// The postal code of the address.
    public let postalCode: String?

    /// The state of the address.
    public let state: String?
}

/// Branding URLs for the ticker.
public struct TickerBranding: Codable, Sendable {
    /// A link to this ticker's company's icon. Icon's are generally smaller, square images
    /// that represent the company at a glance.
    public let iconUrl: String?

    /// A link to this ticker's company's logo.
    public let logoUrl: String?
}

/// The locale of a ticker.
public enum TickerLocale: String, Codable, Sendable, CaseIterable {
    case global
    case us
}

/// The market type of a ticker.
public enum TickerMarket: String, Codable, Sendable, CaseIterable {
    case crypto
    case fx
    case indices
    case otc
    case stocks
}
