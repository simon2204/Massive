// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Paginate through all news for a ticker
    for try await page in client.news(NewsQuery(ticker: "AAPL")) {
        for article in page.results ?? [] {
            print("Title: \(article.title)")
            print("Published: \(article.publishedUtc)")
        }
    }

    // snippet.hide
}
