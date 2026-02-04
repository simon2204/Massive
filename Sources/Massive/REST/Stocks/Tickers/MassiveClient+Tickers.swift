import Fetch
import Foundation

extension MassiveClient {
    // MARK: - Ticker Overview

    /// Fetches comprehensive details for a single ticker.
    ///
    /// Returns detailed information about a ticker including company description,
    /// market cap, address, and more.
    ///
    /// - Parameter query: The query parameters specifying the ticker and optional date.
    /// - Returns: A response containing the ticker details.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let details = try await client.tickerOverview(TickerOverviewQuery(ticker: "AAPL"))
    /// if let result = details.results {
    ///     print("\(result.name): \(result.description ?? "")")
    /// }
    /// ```
    public func tickerOverview(_ query: TickerOverviewQuery) async throws -> TickerOverviewResponse {
        try await fetch(query)
    }

    // MARK: - Tickers

    /// Returns an async sequence of tickers matching the query criteria.
    ///
    /// Automatically paginates through all results. The sequence is lazy,
    /// so pages are only fetched as you iterate.
    ///
    /// - Parameter query: The query parameters for filtering tickers.
    /// - Returns: An async sequence of ticker response pages.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for try await page in client.tickers(TickersQuery(market: .stocks)) {
    ///     for ticker in page.results ?? [] {
    ///         print("\(ticker.ticker): \(ticker.name)")
    ///     }
    /// }
    /// ```
    public func tickers(_ query: TickersQuery) -> PaginatedSequence<TickersResponse, PaginationCursor<TickersQuery>> {
        paginated(query: query) { try await self.fetch($0) }
    }

    // MARK: - Ticker Types

    /// Fetches all ticker types supported by Massive.
    ///
    /// Returns a list of ticker type codes and descriptions.
    ///
    /// - Parameter query: The query parameters for filtering ticker types.
    /// - Returns: A response containing ticker types.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let types = try await client.tickerTypes(TickerTypesQuery(assetClass: .stocks))
    /// for type in types.results ?? [] {
    ///     print("\(type.code): \(type.description)")
    /// }
    /// ```
    public func tickerTypes(_ query: TickerTypesQuery) async throws -> TickerTypesResponse {
        try await fetch(query)
    }

    // MARK: - Related Tickers

    /// Fetches tickers related to the specified ticker.
    ///
    /// Returns a list of related companies based on news and returns data.
    ///
    /// - Parameter query: The query parameters specifying the ticker.
    /// - Returns: A response containing related tickers.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let related = try await client.relatedTickers(RelatedTickersQuery(ticker: "AAPL"))
    /// for item in related.results ?? [] {
    ///     print("Related: \(item.ticker)")
    /// }
    /// ```
    public func relatedTickers(_ query: RelatedTickersQuery) async throws -> RelatedTickersResponse {
        try await fetch(query)
    }
}
