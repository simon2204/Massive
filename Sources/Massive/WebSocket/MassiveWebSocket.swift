import Fetch
import Foundation
import Logging
import NIOCore
import NIOPosix
import WebSocketKit

/// A WebSocket client for streaming real-time stock market data.
///
/// ## Example Usage
///
/// ```swift
/// let ws = MassiveWebSocket(apiKey: "your-api-key")
///
/// // Connect and stream trades
/// for try await message in ws.stream() {
///     switch message {
///     case .trade(let trade):
///         print("Trade: \(trade.symbol) @ \(trade.price)")
///     case .quote(let quote):
///         print("Quote: \(quote.symbol) bid=\(quote.bidPrice) ask=\(quote.askPrice)")
///     default:
///         break
///     }
/// }
/// ```
public actor MassiveWebSocket {
    // MARK: - Endpoints
    
    /// Real-time stocks WebSocket endpoint.
    public static let stocksEndpoint = "wss://socket.massive.com/stocks"
    
    /// 15-minute delayed stocks WebSocket endpoint.
    public static let stocksDelayedEndpoint = "wss://delayed.massive.com/stocks"
    
    // MARK: - Properties
    
    /// The API key for authentication.
    private let apiKey: String

    /// The WebSocket endpoint URL.
    private let endpoint: String

    /// The event loop group for WebSocket connections.
    private let eventLoopGroup: EventLoopGroup

    /// Whether we own the event loop group and should shut it down.
    private let ownsEventLoopGroup: Bool

    /// The active WebSocket connection.
    private var webSocket: WebSocket?

    /// Pending subscriptions to send after authentication.
    private var pendingSubscriptions: [WebSocketSubscription] = []

    /// Whether authentication has completed.
    private var isAuthenticated = false

    /// JSON decoder for incoming messages.
    private let decoder = JSONDataDecoder(keyDecodingStrategy: .useDefaultKeys)

    /// JSON encoder for outgoing messages.
    private let encoder = JSONEncoder()

    /// Logger for WebSocket operations.
    private let logger: Logger

    /// Creates a new WebSocket client for stock data streaming.
    ///
    /// - Parameters:
    ///   - apiKey: Your Massive API key.
    ///   - endpoint: The WebSocket endpoint URL. Defaults to real-time stocks.
    ///     Use `stocksDelayedEndpoint` for 15-minute delayed data.
    ///   - eventLoopGroup: Optional event loop group. If not provided, a new one is created.
    ///   - logger: Optional logger for WebSocket operations. Defaults to a logger labeled "MassiveWebSocket".
    public init(
        apiKey: String,
        endpoint: String = MassiveWebSocket.stocksEndpoint,
        eventLoopGroup: EventLoopGroup? = nil,
        logger: Logger? = nil
    ) {
        self.apiKey = apiKey
        self.endpoint = endpoint
        self.logger = logger ?? Logger(label: "MassiveWebSocket")
        if let group = eventLoopGroup {
            self.eventLoopGroup = group
            self.ownsEventLoopGroup = false
        } else {
            self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            self.ownsEventLoopGroup = true
        }
    }

    deinit {
        if ownsEventLoopGroup {
            do {
                try eventLoopGroup.syncShutdownGracefully()
            } catch {
                logger.error("Failed to shutdown event loop group: \(error)")
            }
        }
    }

    /// Connects to the WebSocket and returns an async stream of messages.
    ///
    /// - Parameter subscriptions: Initial subscriptions to make after connecting.
    /// - Returns: An async stream of WebSocket messages.
    public func stream(
        subscriptions: [WebSocketSubscription] = []
    ) -> AsyncThrowingStream<WebSocketMessage, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    try await self.connect(
                        subscriptions: subscriptions,
                        continuation: continuation
                    )
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    /// Subscribes to additional channels while connected.
    ///
    /// - Parameter subscription: The subscription to add.
    public func subscribe(_ subscription: WebSocketSubscription) async throws {
        if isAuthenticated, let ws = webSocket {
            try await send(subscription, on: ws)
        } else {
            pendingSubscriptions.append(subscription)
        }
    }

    /// Unsubscribes from channels while connected.
    ///
    /// - Parameter subscription: The unsubscription request.
    public func unsubscribe(_ subscription: WebSocketSubscription) async throws {
        guard let ws = webSocket else { return }
        try await send(subscription, on: ws)
    }

    /// Disconnects from the WebSocket.
    public func disconnect() async {
        do {
            try await webSocket?.close()
        } catch {
            logger.warning("Failed to close WebSocket gracefully: \(error)")
        }
        webSocket = nil
        isAuthenticated = false
    }

    // MARK: - Private

    private func connect(
        subscriptions: [WebSocketSubscription],
        continuation: AsyncThrowingStream<WebSocketMessage, Error>.Continuation
    ) async throws {
        pendingSubscriptions = subscriptions

        let promise = eventLoopGroup.any().makePromise(of: Void.self)
        
        WebSocket.connect(
            to: endpoint,
            on: eventLoopGroup
        ) { [weak self] ws in
            guard let self = self else { return }

            Task {
                await self.setWebSocket(ws)
            }

            ws.onText { [weak self] ws, text in
                guard let self = self else { return }
                Task {
                    await self.handleText(text, ws: ws, continuation: continuation)
                }
            }

            ws.onClose.whenComplete { result in
                continuation.finish()
                promise.succeed(())
            }
        }.cascadeFailure(to: promise)
        
        try await promise.futureResult.get()
    }

    private func setWebSocket(_ ws: WebSocket) {
        self.webSocket = ws
    }

    private func handleText(
        _ text: String,
        ws: WebSocket,
        continuation: AsyncThrowingStream<WebSocketMessage, Error>.Continuation
    ) async {
        guard let data = text.data(using: .utf8) else { return }

        // Messages come as JSON arrays
        do {
            // Try to decode as array first
            if let messages = try? decoder.decode([EventTypePeek].self, from: data) {
                for (index, peek) in messages.enumerated() {
                    let message = parseMessage(peek.ev, from: data, index: index)
                    await handleMessage(message, ws: ws, continuation: continuation)
                }
            } else if let peek = try? decoder.decode(EventTypePeek.self, from: data) {
                // Single message
                let message = parseMessage(peek.ev, from: data, index: nil)
                await handleMessage(message, ws: ws, continuation: continuation)
            }
        }
    }

    private func parseMessage(_ eventType: String, from data: Data, index: Int?) -> WebSocketMessage {
        do {
            // If index is provided, decode from array
            if let index = index {
                switch eventType {
                case "status":
                    let array = try decoder.decode([WebSocketStatus].self, from: data)
                    return .status(array[index])
                case "A":
                    let array = try decoder.decode([StreamAggregate].self, from: data)
                    return .aggregateSecond(array[index])
                case "AM":
                    let array = try decoder.decode([StreamAggregate].self, from: data)
                    return .aggregateMinute(array[index])
                case "T":
                    let array = try decoder.decode([StreamTrade].self, from: data)
                    return .trade(array[index])
                case "Q":
                    let array = try decoder.decode([StreamQuote].self, from: data)
                    return .quote(array[index])
                case "LULD":
                    let array = try decoder.decode([StreamLULD].self, from: data)
                    return .luld(array[index])
                case "NOI":
                    let array = try decoder.decode([StreamImbalance].self, from: data)
                    return .imbalance(array[index])
                case "FMV":
                    let array = try decoder.decode([StreamFMV].self, from: data)
                    return .fairMarketValue(array[index])
                default:
                    return .unknown(eventType)
                }
            } else {
                // Single message
                switch eventType {
                case "status":
                    return .status(try decoder.decode(WebSocketStatus.self, from: data))
                case "A":
                    return .aggregateSecond(try decoder.decode(StreamAggregate.self, from: data))
                case "AM":
                    return .aggregateMinute(try decoder.decode(StreamAggregate.self, from: data))
                case "T":
                    return .trade(try decoder.decode(StreamTrade.self, from: data))
                case "Q":
                    return .quote(try decoder.decode(StreamQuote.self, from: data))
                case "LULD":
                    return .luld(try decoder.decode(StreamLULD.self, from: data))
                case "NOI":
                    return .imbalance(try decoder.decode(StreamImbalance.self, from: data))
                case "FMV":
                    return .fairMarketValue(try decoder.decode(StreamFMV.self, from: data))
                default:
                    return .unknown(eventType)
                }
            }
        } catch {
            logger.debug("Failed to parse message with event type '\(eventType)': \(error)")
            return .unknown(eventType)
        }
    }

    private func handleMessage(
        _ message: WebSocketMessage,
        ws: WebSocket,
        continuation: AsyncThrowingStream<WebSocketMessage, Error>.Continuation
    ) async {
        switch message {
        case .status(let status):
            if status.status == "connected" {
                // Send authentication
                let auth = AuthMessage(apiKey: apiKey)
                do {
                    try await send(auth, on: ws)
                } catch {
                    logger.error("Failed to send authentication: \(error)")
                    continuation.finish(throwing: error)
                    return
                }
            } else if status.status == "auth_success" {
                isAuthenticated = true
                // Send pending subscriptions
                for subscription in pendingSubscriptions {
                    do {
                        try await send(subscription, on: ws)
                    } catch {
                        logger.error("Failed to send subscription \(subscription.action) for \(subscription.params): \(error)")
                    }
                }
                pendingSubscriptions.removeAll()
            }
            continuation.yield(message)
        default:
            continuation.yield(message)
        }
    }

    private func send<T: Encodable>(_ message: T, on ws: WebSocket) async throws {
        let data = try encoder.encode(message)
        guard let string = String(data: data, encoding: .utf8) else { return }
        try await ws.send(string)
    }
}
