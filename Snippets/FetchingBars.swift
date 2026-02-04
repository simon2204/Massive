// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    // Create a client with your API key
    let client = MassiveClient(apiKey: apiKey)

    // Paginate through daily bars for Apple stock
    let query = BarsQuery(
        ticker: "AAPL",
        from: "2024-01-01",
        to: "2024-01-31"
    )
    
    for try await page in client.bars(query) {
        for bar in page.results ?? [] {
            print("Date: \(bar.timestamp), Open: \(bar.open), Close: \(bar.close)")
        }
    }

    // snippet.hide
}
