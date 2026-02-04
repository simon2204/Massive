import Foundation

/// Query parameters for the Risk Categories endpoint.
///
/// Retrieves the taxonomy of risk factor categories used for classification.
///
/// Use Cases: Understanding risk classification system, filtering risk factors.
///
/// ## Example
/// ```swift
/// // Get all risk categories
/// let query = RiskCategoriesQuery()
///
/// // Filter by primary category
/// let query = RiskCategoriesQuery(primaryCategory: "Operational")
/// ```
public struct RiskCategoriesQuery: APIQuery {
    /// Taxonomy version identifier (e.g., "1.0", "1.1").
    public let taxonomy: Double?

    /// Top-level risk category filter.
    public let primaryCategory: String?

    /// Mid-level risk category filter.
    public let secondaryCategory: String?

    /// Most specific risk classification filter.
    public let tertiaryCategory: String?

    /// Maximum results (default 200).
    public let limit: Int?

    /// Sort columns with direction.
    public let sort: String?

    public init(
        taxonomy: Double? = nil,
        primaryCategory: String? = nil,
        secondaryCategory: String? = nil,
        tertiaryCategory: String? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.taxonomy = taxonomy
        self.primaryCategory = primaryCategory
        self.secondaryCategory = secondaryCategory
        self.tertiaryCategory = tertiaryCategory
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/taxonomies/v1/risk-factors"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("taxonomy", taxonomy)
        builder.add("primary_category", primaryCategory)
        builder.add("secondary_category", secondaryCategory)
        builder.add("tertiary_category", tertiaryCategory)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
