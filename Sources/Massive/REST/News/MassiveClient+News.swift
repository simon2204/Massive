import Fetch
import Foundation

extension MassiveClient {
    /// Fetches news articles from the Massive API.
    ///
    /// Returns news articles matching the query parameters, including sentiment analysis
    /// and related ticker information.
    ///
    /// - Parameter query: The query parameters to filter news results.
    /// - Returns: A response containing matching news articles.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let news = try await client.news(NewsQuery(ticker: "AAPL", limit: 10))
    /// for article in news.results {
    ///     print("\(article.title) - \(article.publisher.name)")
    /// }
    /// ```
    public func news(_ query: NewsQuery = NewsQuery()) async throws -> NewsResponse {
        try await fetch(query)
    }

    /// Returns an async sequence that automatically paginates through all news results.
    ///
    /// Use this method when you need to fetch more results than a single page allows.
    /// The sequence automatically follows pagination cursors until all results are retrieved.
    ///
    /// - Parameter query: The query parameters to filter news results.
    /// - Returns: An async sequence of news response pages.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for try await page in client.allNews(NewsQuery(ticker: "AAPL")) {
    ///     for article in page.results {
    ///         print(article.title)
    ///     }
    /// }
    /// ```
    public func allNews(_ query: NewsQuery = NewsQuery()) -> PaginatedSequence<NewsResponse, PaginationCursor<NewsQuery>> {
        paginated(query: query) { try await self.fetch($0) }
    }
}
