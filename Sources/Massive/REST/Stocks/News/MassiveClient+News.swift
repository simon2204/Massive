import Fetch
import Foundation

extension MassiveClient {
    /// Returns an async sequence of news articles matching the query criteria.
    ///
    /// Automatically paginates through all results. The sequence is lazy,
    /// so pages are only fetched as you iterate.
    ///
    /// - Parameter query: The query parameters to filter news results.
    /// - Returns: An async sequence of news response pages.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for try await page in client.news(NewsQuery(ticker: "AAPL")) {
    ///     for article in page.results ?? [] {
    ///         print("\(article.title) - \(article.publisher.name)")
    ///     }
    /// }
    /// ```
    public func news(_ query: NewsQuery = NewsQuery()) -> PaginatedSequence<NewsResponse, PaginationCursor<NewsQuery>> {
        paginated(query: query) { try await self.fetch($0) }
    }
}
