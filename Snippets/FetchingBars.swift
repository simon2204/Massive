// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    // Create a client with your API key
    let client = MassiveClient(apiKey: apiKey)

    // Fetch daily bars for Apple stock
    let response = try await client.bars(BarsQuery(
        ticker: "AAPL",
        from: "2024-01-01",
        to: "2024-01-31"
    ))

    // Access the bar data
    for bar in response.results ?? [] {
        print("Date: \(bar.timestamp), Open: \(bar.open), Close: \(bar.close)")
    }

    // snippet.hide
}
