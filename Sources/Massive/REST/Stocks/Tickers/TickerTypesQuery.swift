import Foundation

/// Query parameters for the Ticker Types endpoint.
///
/// List all ticker types that Massive supports.
///
/// Use Cases: Understanding available ticker types, filtering tickers by type.
///
/// ## Example
/// ```swift
/// // Get all ticker types
/// let query = TickerTypesQuery()
///
/// // Get ticker types for stocks in the US
/// let query = TickerTypesQuery(assetClass: .stocks, locale: .us)
/// ```
public struct TickerTypesQuery: APIQuery {
    /// Filter by asset class.
    public var assetClass: TickerAssetClass?

    /// Filter by locale.
    public var locale: TickerLocale?

    public init(assetClass: TickerAssetClass? = nil, locale: TickerLocale? = nil) {
        self.assetClass = assetClass
        self.locale = locale
    }

    public var path: String {
        "/v3/reference/tickers/types"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("asset_class", assetClass)
        builder.add("locale", locale)
        return builder.build()
    }
}

/// Asset class for ticker types.
public enum TickerAssetClass: String, Codable, Sendable, CaseIterable {
    case crypto
    case fx
    case indices
    case options
    case stocks
}
