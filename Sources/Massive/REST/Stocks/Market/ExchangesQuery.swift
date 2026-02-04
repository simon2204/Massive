import Foundation

/// Query parameters for the Exchanges endpoint.
///
/// List all exchanges that Massive knows about.
///
/// Use Cases: Exchange reference data, mapping exchange IDs, regulatory compliance.
///
/// ## Example
/// ```swift
/// // All exchanges
/// let query = ExchangesQuery()
///
/// // Only US stock exchanges
/// let query = ExchangesQuery(assetClass: .stocks, locale: .us)
/// ```
public struct ExchangesQuery: APIQuery {
    /// Filter by asset class.
    public let assetClass: MarketAssetClass?

    /// Filter by locale.
    public let locale: MarketLocale?

    public init(assetClass: MarketAssetClass? = nil, locale: MarketLocale? = nil) {
        self.assetClass = assetClass
        self.locale = locale
    }

    public var path: String {
        "/v3/reference/exchanges"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("asset_class", assetClass)
        builder.add("locale", locale)
        return builder.build()
    }
}
