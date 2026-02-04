// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Fetch news for a specific ticker
    let response = try await client.news(NewsQuery(ticker: "AAPL"))

    for article in response.results ?? [] {
        print("Title: \(article.title)")
        print("Published: \(article.publishedUtc)")
    }

    // Paginate through all news
    for try await page in client.allNews(NewsQuery(ticker: "AAPL")) {
        for article in page.results ?? [] {
            print(article.title)
        }
    }

    // snippet.hide
}
