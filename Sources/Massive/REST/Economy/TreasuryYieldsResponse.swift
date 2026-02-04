import Foundation

/// Response from the Treasury Yields endpoint.
public struct TreasuryYieldsResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of Treasury yield observations.
    public let results: [TreasuryYield]?

    /// A Treasury yield curve observation for a single date.
    public struct TreasuryYield: Codable, Sendable {
        /// Calendar date (YYYY-MM-DD).
        public let date: String?

        /// 1-month Treasury market yield.
        public let yield1Month: Double?

        /// 3-month Treasury market yield.
        public let yield3Month: Double?

        /// 6-month Treasury market yield.
        public let yield6Month: Double?

        /// 1-year Treasury market yield.
        public let yield1Year: Double?

        /// 2-year Treasury market yield.
        public let yield2Year: Double?

        /// 3-year Treasury market yield.
        public let yield3Year: Double?

        /// 5-year Treasury market yield.
        public let yield5Year: Double?

        /// 7-year Treasury market yield.
        public let yield7Year: Double?

        /// 10-year Treasury market yield.
        public let yield10Year: Double?

        /// 20-year Treasury market yield.
        public let yield20Year: Double?

        /// 30-year Treasury market yield.
        public let yield30Year: Double?

        private enum CodingKeys: String, CodingKey {
            case date
            case yield1Month = "yield_1_month"
            case yield3Month = "yield_3_month"
            case yield6Month = "yield_6_month"
            case yield1Year = "yield_1_year"
            case yield2Year = "yield_2_year"
            case yield3Year = "yield_3_year"
            case yield5Year = "yield_5_year"
            case yield7Year = "yield_7_year"
            case yield10Year = "yield_10_year"
            case yield20Year = "yield_20_year"
            case yield30Year = "yield_30_year"
        }
    }
}
