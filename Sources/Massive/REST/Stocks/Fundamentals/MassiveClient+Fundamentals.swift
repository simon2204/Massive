import Foundation

extension MassiveClient {
    // MARK: - Balance Sheets

    /// Fetches balance sheet data from SEC filings.
    ///
    /// Returns balance sheet components including assets, liabilities, and equity.
    ///
    /// - Parameter query: The query parameters for filtering balance sheets.
    /// - Returns: A response containing the list of balance sheets.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.balanceSheets(BalanceSheetsQuery(tickers: "AAPL"))
    /// for bs in response.results ?? [] {
    ///     print("Total Assets: \(bs.totalAssets?.value ?? 0)")
    /// }
    /// ```
    public func balanceSheets(_ query: BalanceSheetsQuery = BalanceSheetsQuery()) async throws -> BalanceSheetsResponse {
        try await fetch(query)
    }

    // MARK: - Cash Flow Statements

    /// Fetches cash flow statement data from SEC filings.
    ///
    /// Returns cash flows from operating, investing, and financing activities.
    ///
    /// - Parameter query: The query parameters for filtering cash flow statements.
    /// - Returns: A response containing the list of cash flow statements.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.cashFlowStatements(CashFlowStatementsQuery(tickers: "AAPL"))
    /// for cf in response.results ?? [] {
    ///     print("Free Cash Flow: \(cf.freeCashFlow?.value ?? 0)")
    /// }
    /// ```
    public func cashFlowStatements(_ query: CashFlowStatementsQuery = CashFlowStatementsQuery()) async throws -> CashFlowStatementsResponse {
        try await fetch(query)
    }

    // MARK: - Income Statements

    /// Fetches income statement data from SEC filings.
    ///
    /// Returns revenue, expenses, and earnings information.
    ///
    /// - Parameter query: The query parameters for filtering income statements.
    /// - Returns: A response containing the list of income statements.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.incomeStatements(IncomeStatementsQuery(tickers: "AAPL"))
    /// for is in response.results ?? [] {
    ///     print("Revenue: \(is.totalRevenue?.value ?? 0)")
    ///     print("Net Income: \(is.netIncome?.value ?? 0)")
    /// }
    /// ```
    public func incomeStatements(_ query: IncomeStatementsQuery = IncomeStatementsQuery()) async throws -> IncomeStatementsResponse {
        try await fetch(query)
    }

    // MARK: - Financial Ratios

    /// Fetches calculated financial ratios.
    ///
    /// Returns valuation, profitability, and liquidity ratios.
    ///
    /// - Parameter query: The query parameters for filtering ratios.
    /// - Returns: A response containing the list of financial ratios.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.ratios(RatiosQuery(ticker: "AAPL"))
    /// for ratios in response.results ?? [] {
    ///     print("P/E: \(ratios.priceToEarnings ?? 0)")
    ///     print("ROE: \(ratios.returnOnEquity ?? 0)")
    /// }
    /// ```
    public func ratios(_ query: RatiosQuery = RatiosQuery()) async throws -> RatiosResponse {
        try await fetch(query)
    }

    // MARK: - Short Interest

    /// Fetches short interest data.
    ///
    /// Returns the number of shares sold short and days to cover.
    ///
    /// - Parameter query: The query parameters for filtering short interest.
    /// - Returns: A response containing the list of short interest records.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.shortInterest(ShortInterestQuery(ticker: "GME"))
    /// for si in response.results ?? [] {
    ///     print("Short Interest: \(si.shortInterest ?? 0)")
    ///     print("Days to Cover: \(si.daysToCover ?? 0)")
    /// }
    /// ```
    public func shortInterest(_ query: ShortInterestQuery = ShortInterestQuery()) async throws -> ShortInterestResponse {
        try await fetch(query)
    }

    // MARK: - Short Volume

    /// Fetches daily short volume data.
    ///
    /// Returns short selling volume and ratio for each trading day.
    ///
    /// - Parameter query: The query parameters for filtering short volume.
    /// - Returns: A response containing the list of short volume records.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.shortVolume(ShortVolumeQuery(ticker: "GME"))
    /// for sv in response.results ?? [] {
    ///     print("\(sv.date ?? ""): \(sv.shortVolumeRatio ?? 0)% short")
    /// }
    /// ```
    public func shortVolume(_ query: ShortVolumeQuery = ShortVolumeQuery()) async throws -> ShortVolumeResponse {
        try await fetch(query)
    }

    // MARK: - Float

    /// Fetches float data showing shares available for public trading.
    ///
    /// Returns the number and percentage of freely tradable shares.
    ///
    /// - Parameter query: The query parameters for filtering float data.
    /// - Returns: A response containing the list of float records.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.float(FloatQuery(ticker: "AAPL"))
    /// for f in response.results ?? [] {
    ///     print("Free Float: \(f.freeFloat ?? 0) (\(f.freeFloatPercent ?? 0)%)")
    /// }
    /// ```
    public func float(_ query: FloatQuery = FloatQuery()) async throws -> FloatResponse {
        try await fetch(query)
    }
}
