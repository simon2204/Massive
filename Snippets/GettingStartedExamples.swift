// snippet.hide
import Massive

func examples() async throws {
    // snippet.show

    // snippet.create-client
    import Massive

    let client = MassiveClient(apiKey: "your-api-key")
    // snippet.end

    // snippet.client-config
    let client = MassiveClient(
        apiKey: "your-api-key",
        rateLimiter: RateLimiter(requests: 5, per: .seconds(1)),
        retry: Retry(baseDelay: .seconds(1), maxAttempts: 5)
    )
    // snippet.end

    // snippet.pagination
    for try await page in client.news(NewsQuery(ticker: "AAPL")) {
        for article in page.results ?? [] {
            print(article.title)
        }
        // Break early if you only need the first page
    }
    // snippet.end

    // snippet.error-handling
    do {
        for try await _ in client.news(NewsQuery(ticker: "INVALID")) {
            break
        }
    } catch let error as MassiveError {
        switch error {
        case .httpError(let statusCode, let data):
            print("HTTP \(statusCode): \(String(data: data, encoding: .utf8) ?? "")")
        case .invalidResponse:
            print("Invalid response from server")
        }
    }
    // snippet.end

    // snippet.hide
}
