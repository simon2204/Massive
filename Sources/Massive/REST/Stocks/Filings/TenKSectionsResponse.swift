import Foundation

/// Response from the 10-K Sections endpoint.
public struct TenKSectionsResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of 10-K section results.
    public let results: [TenKSection]?

    /// A section from a 10-K filing.
    public struct TenKSection: Codable, Sendable {
        /// SEC Central Index Key (10 digits, zero-padded).
        public let cik: String?

        /// Date when the filing was submitted (YYYY-MM-DD).
        public let filingDate: String?

        /// SEC URL for the full filing.
        public let filingUrl: String?

        /// Period end date (YYYY-MM-DD).
        public let periodEnd: String?

        /// Standardized section identifier.
        public let section: String?

        /// Full raw text content of the section.
        public let text: String?

        /// Stock ticker symbol.
        public let ticker: String?
    }
}
