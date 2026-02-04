// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Get real-time snapshot for a single ticker
    let snapshot = try await client.tickerSnapshot(SingleTickerSnapshotQuery(ticker: "AAPL"))
    if let ticker = snapshot.ticker {
        print("Last Price: $\(ticker.lastTrade?.p ?? 0)")
        print("Today's Change: \(ticker.todaysChangePerc ?? 0)%")
    }

    // Get top market gainers
    let gainers = try await client.topMovers(TopMoversQuery(direction: .gainers))
    print("Top Gainers:")
    for ticker in gainers.tickers ?? [] {
        print("  \(ticker.ticker ?? ""): +\(ticker.todaysChangePerc ?? 0)%")
    }

    // Get top market losers
    let losers = try await client.topMovers(TopMoversQuery(direction: .losers))
    print("Top Losers:")
    for ticker in losers.tickers ?? [] {
        print("  \(ticker.ticker ?? ""): \(ticker.todaysChangePerc ?? 0)%")
    }

    // snippet.hide
}
