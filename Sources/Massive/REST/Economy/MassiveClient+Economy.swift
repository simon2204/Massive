import Foundation

extension MassiveClient {
    // MARK: - Treasury Yields

    /// Fetches daily Treasury yield curve data.
    ///
    /// Returns yields for maturities from 1 month to 30 years,
    /// sourced from Federal Reserve data.
    ///
    /// - Parameter query: The query parameters for filtering yields.
    /// - Returns: A response containing Treasury yield observations.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.treasuryYields(TreasuryYieldsQuery())
    /// for yield in response.results ?? [] {
    ///     print("\(yield.date ?? ""): 10Y=\(yield.yield10Year ?? 0)%")
    /// }
    /// ```
    public func treasuryYields(_ query: TreasuryYieldsQuery = TreasuryYieldsQuery()) async throws -> TreasuryYieldsResponse {
        try await fetch(query)
    }

    // MARK: - Inflation

    /// Fetches inflation indicators including CPI and PCE.
    ///
    /// Returns Consumer Price Index and Personal Consumption Expenditures
    /// data from Federal Reserve sources.
    ///
    /// - Parameter query: The query parameters for filtering inflation data.
    /// - Returns: A response containing inflation observations.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.inflation(InflationQuery())
    /// for obs in response.results ?? [] {
    ///     print("\(obs.date ?? ""): CPI YoY=\(obs.cpiYearOverYear ?? 0)%")
    /// }
    /// ```
    public func inflation(_ query: InflationQuery = InflationQuery()) async throws -> InflationResponse {
        try await fetch(query)
    }

    // MARK: - Inflation Expectations

    /// Fetches market-based and model-based inflation expectations.
    ///
    /// Returns breakeven inflation rates from Treasury yields and
    /// Cleveland Fed inflation expectation models.
    ///
    /// - Parameter query: The query parameters for filtering expectations.
    /// - Returns: A response containing inflation expectation observations.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.inflationExpectations(InflationExpectationsQuery())
    /// for exp in response.results ?? [] {
    ///     print("\(exp.date ?? ""): 5Y Breakeven=\(exp.market5Year ?? 0)%")
    /// }
    /// ```
    public func inflationExpectations(_ query: InflationExpectationsQuery = InflationExpectationsQuery()) async throws -> InflationExpectationsResponse {
        try await fetch(query)
    }

    // MARK: - Labor Market

    /// Fetches labor market indicators.
    ///
    /// Returns unemployment rate, job openings, labor force participation,
    /// and average hourly earnings.
    ///
    /// - Parameter query: The query parameters for filtering labor data.
    /// - Returns: A response containing labor market observations.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.laborMarket(LaborMarketQuery())
    /// for obs in response.results ?? [] {
    ///     print("\(obs.date ?? ""): Unemployment=\(obs.unemploymentRate ?? 0)%")
    /// }
    /// ```
    public func laborMarket(_ query: LaborMarketQuery = LaborMarketQuery()) async throws -> LaborMarketResponse {
        try await fetch(query)
    }
}
