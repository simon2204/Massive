import Foundation

/// Represents a subscription channel for WebSocket streaming.
public enum StockChannel: String, Sendable {
    /// Per-second aggregate bars.
    case aggregateSecond = "A"
    /// Per-minute aggregate bars.
    case aggregateMinute = "AM"
    /// Trade executions.
    case trades = "T"
    /// NBBO quotes.
    case quotes = "Q"
    /// Limit Up - Limit Down events.
    case luld = "LULD"
    /// Net order imbalances.
    case imbalances = "NOI"
    /// Fair market value (Business plan only).
    case fairMarketValue = "FMV"
}

/// A subscription request to send to the WebSocket server.
public struct WebSocketSubscription: Sendable, Encodable {
    /// The action to perform.
    public let action: SubscriptionAction
    /// The parameters for the subscription.
    public let params: String

    public init(action: SubscriptionAction, channel: StockChannel, tickers: [String]) {
        self.action = action
        self.params = tickers.map { "\(channel.rawValue).\($0)" }.joined(separator: ",")
    }

    /// Subscribe to all tickers for a channel.
    public static func subscribeAll(_ channel: StockChannel) -> WebSocketSubscription {
        WebSocketSubscription(action: .subscribe, channel: channel, tickers: ["*"])
    }

    /// Subscribe to specific tickers for a channel.
    public static func subscribe(_ channel: StockChannel, tickers: [String]) -> WebSocketSubscription {
        WebSocketSubscription(action: .subscribe, channel: channel, tickers: tickers)
    }

    /// Subscribe to a single ticker for a channel.
    public static func subscribe(_ channel: StockChannel, ticker: String) -> WebSocketSubscription {
        WebSocketSubscription(action: .subscribe, channel: channel, tickers: [ticker])
    }

    /// Unsubscribe from all tickers for a channel.
    public static func unsubscribeAll(_ channel: StockChannel) -> WebSocketSubscription {
        WebSocketSubscription(action: .unsubscribe, channel: channel, tickers: ["*"])
    }

    /// Unsubscribe from specific tickers for a channel.
    public static func unsubscribe(_ channel: StockChannel, tickers: [String]) -> WebSocketSubscription {
        WebSocketSubscription(action: .unsubscribe, channel: channel, tickers: tickers)
    }

    /// Unsubscribe from a single ticker for a channel.
    public static func unsubscribe(_ channel: StockChannel, ticker: String) -> WebSocketSubscription {
        WebSocketSubscription(action: .unsubscribe, channel: channel, tickers: [ticker])
    }
}

/// The action for a subscription request.
public enum SubscriptionAction: String, Sendable, Encodable {
    case subscribe
    case unsubscribe
}

/// Authentication message to send after connecting.
struct AuthMessage: Encodable {
    let action = "auth"
    let params: String

    init(apiKey: String) {
        self.params = apiKey
    }
}
