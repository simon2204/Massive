import Foundation

extension MassiveClient {
    // MARK: - Single Ticker Snapshot

    /// Fetches the most up-to-date market data for a single traded stock ticker.
    ///
    /// Returns real-time snapshot including day bar, previous day bar, minute bar,
    /// last quote, last trade, and today's change.
    ///
    /// - Parameter query: The query parameters specifying the ticker.
    /// - Returns: A response containing the ticker snapshot.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let snapshot = try await client.tickerSnapshot(SingleTickerSnapshotQuery(ticker: "AAPL"))
    /// if let ticker = snapshot.ticker {
    ///     print("Last trade: \(ticker.lastTrade?.p ?? 0)")
    ///     print("Today's change: \(ticker.todaysChangePerc ?? 0)%")
    /// }
    /// ```
    public func tickerSnapshot(_ query: SingleTickerSnapshotQuery) async throws -> SingleTickerSnapshotResponse {
        try await fetch(query)
    }

    // MARK: - Full Market Snapshot

    /// Fetches the most up-to-date market data for all traded stock tickers.
    ///
    /// Returns snapshots for all tickers, optionally filtered by a list of specific tickers.
    ///
    /// - Parameter query: The query parameters specifying optional filters.
    /// - Returns: A response containing snapshots for all tickers.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Get all tickers
    /// let allSnapshots = try await client.marketSnapshot(FullMarketSnapshotQuery())
    ///
    /// // Get specific tickers
    /// let snapshots = try await client.marketSnapshot(FullMarketSnapshotQuery(
    ///     tickers: ["AAPL", "GOOGL", "MSFT"]
    /// ))
    /// for ticker in snapshots.tickers ?? [] {
    ///     print("\(ticker.ticker ?? ""): \(ticker.todaysChangePerc ?? 0)%")
    /// }
    /// ```
    public func marketSnapshot(_ query: FullMarketSnapshotQuery) async throws -> FullMarketSnapshotResponse {
        try await fetch(query)
    }

    // MARK: - Universal Snapshot

    /// Fetches snapshots for assets of all types.
    ///
    /// Supports stocks, options, indices, forex, and crypto in a single request.
    ///
    /// - Parameter query: The query parameters specifying the tickers.
    /// - Returns: A response containing unified snapshots for all requested tickers.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let snapshots = try await client.universalSnapshot(UnifiedSnapshotQuery(
    ///     tickers: ["AAPL", "O:AAPL230616C00150000", "X:BTCUSD"]
    /// ))
    /// for result in snapshots.results ?? [] {
    ///     print("\(result.ticker ?? "") (\(result.type ?? "")): \(result.lastTrade?.price ?? 0)")
    /// }
    /// ```
    public func universalSnapshot(_ query: UnifiedSnapshotQuery) async throws -> UnifiedSnapshotResponse {
        try await fetch(query)
    }

    // MARK: - Top Market Movers

    /// Fetches the current top 20 gainers or losers of the day.
    ///
    /// Returns the top movers in the stocks/equities markets.
    ///
    /// - Parameter query: The query parameters specifying the direction (gainers/losers).
    /// - Returns: A response containing the top movers.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Get top gainers
    /// let gainers = try await client.topMovers(TopMoversQuery(direction: .gainers))
    /// for ticker in gainers.tickers ?? [] {
    ///     print("\(ticker.ticker ?? ""): +\(ticker.todaysChangePerc ?? 0)%")
    /// }
    ///
    /// // Get top losers
    /// let losers = try await client.topMovers(TopMoversQuery(direction: .losers))
    /// for ticker in losers.tickers ?? [] {
    ///     print("\(ticker.ticker ?? ""): \(ticker.todaysChangePerc ?? 0)%")
    /// }
    /// ```
    public func topMovers(_ query: TopMoversQuery) async throws -> TopMoversResponse {
        try await fetch(query)
    }
}
