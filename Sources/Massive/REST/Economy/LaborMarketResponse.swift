import Foundation

/// Response from the Labor Market endpoint.
public struct LaborMarketResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of labor market observations.
    public let results: [LaborMarketObservation]?

    /// A labor market data observation for a single date.
    public struct LaborMarketObservation: Codable, Sendable {
        /// Calendar date (YYYY-MM-DD).
        public let date: String?

        /// Average hourly earnings of all employees on private nonfarm payrolls in USD.
        public let avgHourlyEarnings: Double?

        /// Total nonfarm job openings in thousands.
        public let jobOpenings: Double?

        /// Civilian labor force participation rate as a percentage.
        public let laborForceParticipationRate: Double?

        /// Civilian unemployment rate as a percentage of the labor force.
        public let unemploymentRate: Double?
    }
}
