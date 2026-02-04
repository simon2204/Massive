import Foundation

/// Response from the Risk Factors endpoint.
public struct RiskFactorsResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of categorized risk factors.
    public let results: [RiskFactor]?

    /// A categorized risk factor from an SEC filing.
    public struct RiskFactor: Codable, Sendable {
        /// SEC Central Index Key (10 digits, zero-padded).
        public let cik: String?

        /// Filing submission date (YYYY-MM-DD).
        public let filingDate: String?

        /// Stock ticker symbol.
        public let ticker: String?

        /// Top-level risk classification.
        public let primaryCategory: String?

        /// Mid-level risk classification.
        public let secondaryCategory: String?

        /// Most specific risk classification.
        public let tertiaryCategory: String?

        /// Text excerpt supporting the classification.
        public let supportingText: String?
    }
}
