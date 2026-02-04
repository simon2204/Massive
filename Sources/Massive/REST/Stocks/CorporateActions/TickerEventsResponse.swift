import Foundation

/// Response from the Ticker Events endpoint.
public struct TickerEventsResponse: Codable, Sendable {
    /// A request ID assigned by the server.
    public let requestId: String?

    /// The results containing events.
    public let results: TickerEventsResults?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case results
    }
}

/// Container for ticker events results.
public struct TickerEventsResults: Codable, Sendable {
    /// The name of the entity.
    public let name: String?

    /// Current status of the entity.
    public let status: String?

    /// List of events for this ticker.
    public let events: [TickerEvent]?
}

/// A significant event in a ticker's history.
public struct TickerEvent: Codable, Sendable {
    /// The type of event.
    public let type: String?

    /// The date of the event.
    public let date: String?

    /// Details about a ticker change event.
    public let tickerChange: TickerChangeEvent?

    enum CodingKeys: String, CodingKey {
        case type
        case date
        case tickerChange = "ticker_change"
    }
}

/// Details about a ticker symbol change.
public struct TickerChangeEvent: Codable, Sendable {
    /// The previous ticker symbol.
    public let ticker: String?
}
