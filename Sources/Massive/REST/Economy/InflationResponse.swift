import Foundation

/// Response from the Inflation endpoint.
public struct InflationResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of inflation observations.
    public let results: [InflationObservation]?

    /// An inflation data observation for a single date.
    public struct InflationObservation: Codable, Sendable {
        /// Calendar date (YYYY-MM-DD).
        public let date: String?

        /// Consumer Price Index for All Urban Consumers (headline inflation).
        public let cpi: Double?

        /// Core CPI excluding food and energy.
        public let cpiCore: Double?

        /// Year-over-year percentage change in headline CPI.
        public let cpiYearOverYear: Double?

        /// Personal Consumption Expenditures Price Index.
        public let pce: Double?

        /// Core PCE excluding food and energy.
        public let pceCore: Double?

        /// Nominal Personal Consumption Expenditures in billions of dollars.
        public let pceSpending: Double?
    }
}
