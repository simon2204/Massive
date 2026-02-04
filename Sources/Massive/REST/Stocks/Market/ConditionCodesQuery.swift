import Foundation

/// Query parameters for the Condition Codes endpoint.
///
/// List condition codes used in trade and quote data.
///
/// Use Cases: Understanding trade conditions, filtering trades, compliance reporting.
///
/// ## Example
/// ```swift
/// // All stock trade conditions
/// let query = ConditionCodesQuery(assetClass: .stocks, dataType: .trade)
///
/// // Specific condition by ID
/// let query = ConditionCodesQuery(id: 2)
/// ```
public struct ConditionCodesQuery: APIQuery {
    /// Filter by asset class.
    public var assetClass: MarketAssetClass?

    /// Filter by data type.
    public var dataType: ConditionDataType?

    /// Filter for a specific condition ID.
    public var id: Int?

    /// Filter by SIP.
    public var sip: SIPType?

    /// Order results.
    public var order: SortOrder?

    /// Limit the number of results (default 10, max 1000).
    public var limit: Int?

    /// Field to sort by.
    public var sort: String?

    public init(
        assetClass: MarketAssetClass? = nil,
        dataType: ConditionDataType? = nil,
        id: Int? = nil,
        sip: SIPType? = nil,
        order: SortOrder? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.assetClass = assetClass
        self.dataType = dataType
        self.id = id
        self.sip = sip
        self.order = order
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/v3/reference/conditions"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("asset_class", assetClass)
        builder.add("data_type", dataType)
        builder.add("id", id)
        builder.add("sip", sip)
        builder.add("order", order)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
