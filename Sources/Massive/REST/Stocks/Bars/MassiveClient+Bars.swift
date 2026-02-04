import Fetch
import Foundation

extension MassiveClient {
    // MARK: - Custom Bars

    /// Returns an async sequence of OHLC bar data for the specified query.
    ///
    /// Automatically paginates through all results. The sequence is lazy,
    /// so pages are only fetched as you iterate.
    ///
    /// - Parameter query: The query parameters specifying ticker, date range, and interval.
    /// - Returns: An async sequence of bar response pages.
    ///
    /// ## Example
    ///
    /// ```swift
    /// for try await page in client.bars(BarsQuery(
    ///     ticker: "AAPL",
    ///     from: "2024-01-01",
    ///     to: "2024-01-31"
    /// )) {
    ///     for bar in page.results ?? [] {
    ///         print("Open: \(bar.o), Close: \(bar.c)")
    ///     }
    /// }
    /// ```
    public func bars(_ query: BarsQuery) -> PaginatedSequence<BarsResponse, PaginationCursor<BarsQuery>> {
        paginated(query: query) { try await self.fetch($0) }
    }

    // MARK: - Daily Market Summary

    /// Fetches the daily OHLC for the entire US stocks market on a specific date.
    ///
    /// Returns aggregated data for all tickers traded on the specified date.
    ///
    /// - Parameter query: The query parameters specifying the date.
    /// - Returns: A response containing OHLC data for all tickers.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let summary = try await client.dailyMarketSummary(DailyMarketSummaryQuery(date: "2024-01-15"))
    /// for bar in summary.results ?? [] {
    ///     print("\(bar.T): Open=\(bar.o), Close=\(bar.c)")
    /// }
    /// ```
    public func dailyMarketSummary(_ query: DailyMarketSummaryQuery) async throws -> DailyMarketSummaryResponse {
        try await fetch(query)
    }

    // MARK: - Daily Ticker Summary

    /// Fetches the open, close, and after-hours prices for a ticker on a specific date.
    ///
    /// Includes pre-market and after-hours trading prices when available.
    ///
    /// - Parameter query: The query parameters specifying the ticker and date.
    /// - Returns: A response containing the daily summary with extended hours data.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let summary = try await client.dailyTickerSummary(DailyTickerSummaryQuery(
    ///     ticker: "AAPL",
    ///     date: "2024-01-15"
    /// ))
    /// print("Open: \(summary.open), Close: \(summary.close)")
    /// if let afterHours = summary.afterHours {
    ///     print("After Hours: \(afterHours)")
    /// }
    /// ```
    public func dailyTickerSummary(_ query: DailyTickerSummaryQuery) async throws -> DailyTickerSummaryResponse {
        try await fetch(query)
    }

    // MARK: - Previous Day Bar

    /// Fetches the previous day's OHLC for a ticker.
    ///
    /// Returns the most recent trading day's data for the specified ticker.
    ///
    /// - Parameter query: The query parameters specifying the ticker.
    /// - Returns: A response containing the previous day's bar.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let prev = try await client.previousDayBar(PreviousDayBarQuery(ticker: "AAPL"))
    /// if let bar = prev.results?.first {
    ///     print("Previous close: \(bar.c)")
    /// }
    /// ```
    public func previousDayBar(_ query: PreviousDayBarQuery) async throws -> PreviousDayBarResponse {
        try await fetch(query)
    }
}
