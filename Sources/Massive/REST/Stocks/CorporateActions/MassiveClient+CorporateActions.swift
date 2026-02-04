import Foundation

extension MassiveClient {
    // MARK: - IPOs

    /// Fetches IPO (Initial Public Offering) data.
    ///
    /// Returns historical and upcoming IPO events with pricing and listing information.
    ///
    /// - Parameter query: The query parameters for filtering IPOs.
    /// - Returns: A response containing the list of IPOs.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.ipos(IPOsQuery(ipoStatus: .pending))
    /// for ipo in response.results ?? [] {
    ///     print("\(ipo.ticker ?? ""): \(ipo.issuerName ?? "") - \(ipo.listingDate ?? "")")
    /// }
    /// ```
    public func ipos(_ query: IPOsQuery = IPOsQuery()) async throws -> IPOsResponse {
        try await fetch(query)
    }

    // MARK: - Stock Splits

    /// Fetches stock split data.
    ///
    /// Returns historical stock splits including forward splits, reverse splits,
    /// and stock dividends with adjustment factors.
    ///
    /// - Parameter query: The query parameters for filtering splits.
    /// - Returns: A response containing the list of splits.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.splits(SplitsQuery(ticker: "AAPL"))
    /// for split in response.results ?? [] {
    ///     print("\(split.executionDate ?? ""): \(split.splitFrom ?? 0)-for-\(split.splitTo ?? 0)")
    /// }
    /// ```
    public func splits(_ query: SplitsQuery = SplitsQuery()) async throws -> SplitsResponse {
        try await fetch(query)
    }

    // MARK: - Dividends

    /// Fetches dividend data.
    ///
    /// Returns historical dividend distributions with cash amounts,
    /// dates, and distribution types.
    ///
    /// - Parameter query: The query parameters for filtering dividends.
    /// - Returns: A response containing the list of dividends.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.dividends(DividendsQuery(ticker: "AAPL"))
    /// for dividend in response.results ?? [] {
    ///     print("\(dividend.exDividendDate ?? ""): $\(dividend.cashAmount ?? 0)")
    /// }
    /// ```
    public func dividends(_ query: DividendsQuery = DividendsQuery()) async throws -> DividendsResponse {
        try await fetch(query)
    }

    // MARK: - Ticker Events

    /// Fetches significant events for a ticker.
    ///
    /// Returns a timeline of events including symbol changes and rebranding.
    /// Useful for tracking historical ticker changes (e.g., FB → META).
    ///
    /// - Parameter query: The query parameters specifying the ticker.
    /// - Returns: A response containing the ticker's event history.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.tickerEvents(TickerEventsQuery(id: "META"))
    /// for event in response.results?.events ?? [] {
    ///     if let change = event.tickerChange {
    ///         print("Changed from \(change.ticker ?? "") on \(event.date ?? "")")
    ///     }
    /// }
    /// ```
    public func tickerEvents(_ query: TickerEventsQuery) async throws -> TickerEventsResponse {
        try await fetch(query)
    }
}
