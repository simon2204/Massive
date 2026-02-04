import Foundation

/// A message received from the WebSocket stream.
public enum WebSocketMessage: Sendable {
    /// Connection status message.
    case status(WebSocketStatus)
    /// Per-second aggregate bar.
    case aggregateSecond(StreamAggregate)
    /// Per-minute aggregate bar.
    case aggregateMinute(StreamAggregate)
    /// Trade execution.
    case trade(StreamTrade)
    /// NBBO quote update.
    case quote(StreamQuote)
    /// Limit Up - Limit Down price band.
    case luld(StreamLULD)
    /// Net order imbalance.
    case imbalance(StreamImbalance)
    /// Fair market value.
    case fairMarketValue(StreamFMV)
    /// Unknown or unsupported event type.
    case unknown(String)
}

/// Connection status from the WebSocket server.
public struct WebSocketStatus: Sendable, Decodable {
    /// The event type (`status`).
    public let eventType: String
    /// The status message (e.g., "connected", "auth_success").
    public let status: String
    /// Additional message from the server.
    public let message: String

    enum CodingKeys: String, CodingKey {
        case eventType = "ev"
        case status
        case message
    }
}

/// Internal helper to peek at event type before full decoding.
struct EventTypePeek: Decodable {
    let ev: String
}
