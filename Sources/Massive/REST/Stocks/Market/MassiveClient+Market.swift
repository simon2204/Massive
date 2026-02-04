import Foundation

extension MassiveClient {
    // MARK: - Exchanges

    /// Fetches the list of exchanges that Massive knows about.
    ///
    /// Returns information about all exchanges including their MIC codes,
    /// asset classes, and participant IDs.
    ///
    /// - Parameter query: The query parameters for filtering exchanges.
    /// - Returns: A response containing the list of exchanges.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.exchanges(ExchangesQuery(assetClass: .stocks))
    /// for exchange in response.results ?? [] {
    ///     print("\(exchange.name) (\(exchange.mic ?? "N/A"))")
    /// }
    /// ```
    public func exchanges(_ query: ExchangesQuery = ExchangesQuery()) async throws -> ExchangesResponse {
        try await fetch(query)
    }

    // MARK: - Market Holidays

    /// Fetches upcoming market holidays.
    ///
    /// Returns a list of upcoming holidays with their dates, affected exchanges,
    /// and market hours (if partially open).
    ///
    /// - Parameter query: The query parameters (currently no filters available).
    /// - Returns: An array of upcoming market holidays.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let holidays = try await client.marketHolidays(MarketHolidaysQuery())
    /// for holiday in holidays {
    ///     print("\(holiday.name ?? ""): \(holiday.date ?? "") - \(holiday.status ?? "")")
    /// }
    /// ```
    public func marketHolidays(_ query: MarketHolidaysQuery = MarketHolidaysQuery()) async throws -> MarketHolidaysResponse {
        try await fetch(query)
    }

    // MARK: - Market Status

    /// Fetches the current market status.
    ///
    /// Returns real-time status information for major exchanges,
    /// currency markets, and whether extended hours trading is active.
    ///
    /// - Parameter query: The query parameters (currently no filters available).
    /// - Returns: A response containing current market status.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let status = try await client.marketStatus(MarketStatusQuery())
    /// print("Market: \(status.market ?? "unknown")")
    /// if status.afterHours == true {
    ///     print("After-hours trading is active")
    /// }
    /// ```
    public func marketStatus(_ query: MarketStatusQuery = MarketStatusQuery()) async throws -> MarketStatusResponse {
        try await fetch(query)
    }

    // MARK: - Condition Codes

    /// Fetches condition codes used in trade and quote data.
    ///
    /// Returns a list of condition codes with their meanings, types,
    /// and rules for how they affect data aggregation.
    ///
    /// - Parameter query: The query parameters for filtering conditions.
    /// - Returns: A response containing the list of condition codes.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.conditionCodes(ConditionCodesQuery(
    ///     assetClass: .stocks,
    ///     dataType: .trade
    /// ))
    /// for condition in response.results ?? [] {
    ///     print("\(condition.id): \(condition.name) - \(condition.description ?? "")")
    /// }
    /// ```
    public func conditionCodes(_ query: ConditionCodesQuery = ConditionCodesQuery()) async throws -> ConditionCodesResponse {
        try await fetch(query)
    }
}
