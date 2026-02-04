// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    // Create a WebSocket client for real-time data
    let ws = MassiveWebSocket(apiKey: apiKey)

    // Subscribe to trades and quotes for specific tickers
    let subscriptions = [
        WebSocketSubscription(action: .subscribe, params: "T.AAPL,T.MSFT"),
        WebSocketSubscription(action: .subscribe, params: "Q.AAPL")
    ]

    // Stream messages
    for try await message in ws.stream(subscriptions: subscriptions) {
        switch message {
        case .trade(let trade):
            print("Trade: \(trade.symbol) @ $\(trade.price)")
        case .quote(let quote):
            print("Quote: \(quote.symbol) bid=\(quote.bidPrice) ask=\(quote.askPrice)")
        case .status(let status):
            print("Status: \(status.status)")
        default:
            break
        }
    }

    // snippet.hide
}
