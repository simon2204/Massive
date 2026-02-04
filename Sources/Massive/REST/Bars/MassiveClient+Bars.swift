import Fetch
import Foundation

extension MassiveClient {
    /// Fetches historical OHLC bar data from the Massive API.
    ///
    /// Returns aggregated Open, High, Low, Close, and volume data for a ticker
    /// over a specified time range and interval.
    ///
    /// - Parameter query: The query parameters specifying ticker, date range, and interval.
    /// - Returns: A response containing the OHLC bar data.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bars = try await client.bars(BarsQuery(
    ///     ticker: "AAPL",
    ///     from: "2024-01-01",
    ///     to: "2024-01-31"
    /// ))
    /// for bar in bars.results ?? [] {
    ///     print("Open: \(bar.o), Close: \(bar.c)")
    /// }
    /// ```
    public func bars(_ query: BarsQuery) async throws -> BarsResponse {
        try await fetch(query)
    }

    /// Returns an async sequence that automatically paginates through all bar results.
    ///
    /// Use this method when fetching large date ranges that may span multiple pages.
    /// The sequence automatically follows pagination cursors until all results are retrieved.
    ///
    /// - Parameter query: The query parameters specifying ticker, date range, and interval.
    /// - Returns: An async sequence of bar response pages.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for try await page in client.allBars(BarsQuery(
    ///     ticker: "AAPL",
    ///     timespan: .minute,
    ///     from: "2024-01-01",
    ///     to: "2024-01-31"
    /// )) {
    ///     for bar in page.results ?? [] {
    ///         print(bar.c)
    ///     }
    /// }
    /// ```
    public func allBars(_ query: BarsQuery) -> PaginatedSequence<BarsResponse, PaginationCursor<BarsQuery>> {
        paginated(query: query) { try await self.fetch($0) }
    }
}
