import Foundation

/// Response from the Condition Codes endpoint.
public struct ConditionCodesResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The total number of results.
    public let count: Int?

    /// The list of condition codes.
    public let results: [ConditionCode]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case count
        case results
        case nextUrl = "next_url"
    }
}

/// A condition code used in trade or quote data.
public struct ConditionCode: Codable, Sendable {
    /// Unique identifier for this condition (unique per data type).
    public let id: Int

    /// The name of this condition.
    public let name: String

    /// A commonly used abbreviation.
    public let abbreviation: String?

    /// The asset class this condition applies to.
    public let assetClass: String

    /// The data types this condition applies to.
    public let dataTypes: [String]?

    /// A description of what this condition means.
    public let description: String?

    /// Exchange-specific mapping indicator.
    public let exchange: Int?

    /// Whether this condition is deprecated.
    public let legacy: Bool?

    /// The type/category of this condition.
    public let type: ConditionType?

    /// SIP code mappings to unified Massive codes.
    public let sipMapping: SIPMapping?

    /// Rules for how this condition affects aggregations.
    public let updateRules: UpdateRules?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation
        case assetClass = "asset_class"
        case dataTypes = "data_types"
        case description
        case exchange
        case legacy
        case type
        case sipMapping = "sip_mapping"
        case updateRules = "update_rules"
    }
}

/// SIP code mappings.
public struct SIPMapping: Codable, Sendable {
    /// CTA (Consolidated Tape Association) mapping.
    public let CTA: String?

    /// UTP (Unlisted Trading Privileges) mapping.
    public let UTP: String?

    /// OPRA (Options Price Reporting Authority) mapping.
    public let OPRA: String?
}

/// Rules for how conditions affect data aggregation.
public struct UpdateRules: Codable, Sendable {
    /// Rules for consolidated tape data.
    public let consolidated: AggregationRules?

    /// Rules for market center data.
    public let marketCenter: AggregationRules?

    enum CodingKeys: String, CodingKey {
        case consolidated
        case marketCenter = "market_center"
    }
}

/// Aggregation rules for a data source.
public struct AggregationRules: Codable, Sendable {
    /// Whether to update high/low prices.
    public let updatesHighLow: Bool?

    /// Whether to update open/close prices.
    public let updatesOpenClose: Bool?

    /// Whether to update volume.
    public let updatesVolume: Bool?

    enum CodingKeys: String, CodingKey {
        case updatesHighLow = "updates_high_low"
        case updatesOpenClose = "updates_open_close"
        case updatesVolume = "updates_volume"
    }
}
