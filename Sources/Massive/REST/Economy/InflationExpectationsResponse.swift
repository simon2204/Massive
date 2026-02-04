import Foundation

/// Response from the Inflation Expectations endpoint.
public struct InflationExpectationsResponse: Codable, Sendable, PaginatedResponse {
    /// URL for fetching the next page of results.
    public let nextUrl: String?

    /// Server-assigned request identifier.
    public let requestId: String

    /// Response status.
    public let status: String

    /// Array of inflation expectation observations.
    public let results: [InflationExpectation]?

    /// An inflation expectation observation for a single date.
    public struct InflationExpectation: Codable, Sendable {
        /// Calendar date (YYYY-MM-DD).
        public let date: String?

        /// 5-year breakeven inflation rate from Treasury yields.
        public let market5Year: Double?

        /// 10-year breakeven inflation rate from Treasury yields.
        public let market10Year: Double?

        /// 5-year forward rate starting 5 years ahead.
        public let forwardYears5To10: Double?

        /// Cleveland Fed 1-year inflation expectation model.
        public let model1Year: Double?

        /// Cleveland Fed 5-year inflation expectation model.
        public let model5Year: Double?

        /// Cleveland Fed 10-year inflation expectation model.
        public let model10Year: Double?

        /// Cleveland Fed 30-year inflation expectation model.
        public let model30Year: Double?

        private enum CodingKeys: String, CodingKey {
            case date
            case market5Year = "market_5_year"
            case market10Year = "market_10_year"
            case forwardYears5To10 = "forward_years_5_to_10"
            case model1Year = "model_1_year"
            case model5Year = "model_5_year"
            case model10Year = "model_10_year"
            case model30Year = "model_30_year"
        }
    }
}
