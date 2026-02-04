import Foundation

/// Response from the Daily Ticker Summary (Open/Close) endpoint.
public struct DailyTickerSummaryResponse: Codable, Sendable {
    /// The open price for the symbol in the given time period.
    public let open: Double

    /// The close price for the symbol in the given time period.
    public let close: Double

    /// The highest price for the symbol in the given time period.
    public let high: Double

    /// The lowest price for the symbol in the given time period.
    public let low: Double

    /// The trading volume of the symbol in the given time period.
    public let volume: Double

    /// The requested date.
    public let from: String

    /// The exchange symbol that this item is traded under.
    public let symbol: String

    /// The status of this request's response.
    public let status: String

    /// The open price of the ticker symbol in pre-market trading.
    public let preMarket: Double?

    /// The close price of the ticker symbol in after-hours trading.
    public let afterHours: Double?

    /// Whether or not this aggregate is for an OTC ticker.
    public let otc: Bool?
}
