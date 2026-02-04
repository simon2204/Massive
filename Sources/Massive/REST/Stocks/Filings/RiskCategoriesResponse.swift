import Foundation

/// Response from the Risk Categories endpoint.
public struct RiskCategoriesResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of risk category definitions.
    public let results: [RiskCategory]?

    /// A risk category from the taxonomy.
    public struct RiskCategory: Codable, Sendable {
        /// Detailed explanation of what this category encompasses.
        public let description: String?

        /// Top-level risk category.
        public let primaryCategory: String?

        /// Mid-level risk category.
        public let secondaryCategory: String?

        /// Most specific risk classification.
        public let tertiaryCategory: String?

        /// Taxonomy version identifier.
        public let taxonomy: Double
    }
}
