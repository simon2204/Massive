// snippet.hide
import Massive

func example() async throws {
    // snippet.show

    let client = MassiveClient(apiKey: "your-api-key")

    // Fetch news for a ticker
    for try await page in client.news(NewsQuery(ticker: "AAPL", limit: 10)) {
        for article in page.results ?? [] {
            print(article.title)
        }
    }

    // Fetch daily bars
    let query = BarsQuery(
        ticker: "AAPL",
        from: "2024-01-01",
        to: "2024-01-31"
    )

    for try await page in client.bars(query) {
        for bar in page.results ?? [] {
            print("Close: \(bar.close)")
        }
    }

    // Get current snapshot
    let snapshot = try await client.tickerSnapshot(SingleTickerSnapshotQuery(ticker: "AAPL"))
    print("Current price: \(snapshot.ticker?.day?.close ?? 0)")

    // Fetch Treasury yields
    let yields = try await client.treasuryYields(TreasuryYieldsQuery())
    for yield in yields.results ?? [] {
        print("\(yield.date ?? ""): 10Y=\(yield.yield10Year ?? 0)%")
    }

    // snippet.hide
}
