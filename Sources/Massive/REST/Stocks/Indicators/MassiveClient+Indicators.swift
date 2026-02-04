import Foundation

extension MassiveClient {
    // MARK: - Simple Moving Average

    /// Fetches the Simple Moving Average (SMA) for a ticker.
    ///
    /// SMA is calculated by averaging the price over a specified number of periods.
    ///
    /// - Parameter query: The query parameters specifying the ticker and settings.
    /// - Returns: A response containing the SMA values.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.sma(SMAQuery(ticker: "AAPL", window: 20))
    /// for value in response.results?.values ?? [] {
    ///     print("SMA: \(value.value ?? 0) at \(value.timestamp ?? 0)")
    /// }
    /// ```
    public func sma(_ query: SMAQuery) async throws -> SMAResponse {
        try await fetch(query)
    }

    // MARK: - Exponential Moving Average

    /// Fetches the Exponential Moving Average (EMA) for a ticker.
    ///
    /// EMA gives more weight to recent prices, making it more responsive to new information.
    ///
    /// - Parameter query: The query parameters specifying the ticker and settings.
    /// - Returns: A response containing the EMA values.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.ema(EMAQuery(ticker: "AAPL", window: 12))
    /// for value in response.results?.values ?? [] {
    ///     print("EMA: \(value.value ?? 0)")
    /// }
    /// ```
    public func ema(_ query: EMAQuery) async throws -> EMAResponse {
        try await fetch(query)
    }

    // MARK: - Moving Average Convergence/Divergence

    /// Fetches the Moving Average Convergence/Divergence (MACD) for a ticker.
    ///
    /// MACD shows the relationship between two EMAs and includes a signal line
    /// for identifying potential buy/sell signals.
    ///
    /// - Parameter query: The query parameters specifying the ticker and settings.
    /// - Returns: A response containing the MACD, signal, and histogram values.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.macd(MACDQuery(ticker: "AAPL"))
    /// for value in response.results?.values ?? [] {
    ///     print("MACD: \(value.value ?? 0), Signal: \(value.signal ?? 0)")
    /// }
    /// ```
    public func macd(_ query: MACDQuery) async throws -> MACDResponse {
        try await fetch(query)
    }

    // MARK: - Relative Strength Index

    /// Fetches the Relative Strength Index (RSI) for a ticker.
    ///
    /// RSI measures the speed and magnitude of price movements on a scale of 0-100.
    /// Values above 70 typically indicate overbought conditions, below 30 oversold.
    ///
    /// - Parameter query: The query parameters specifying the ticker and settings.
    /// - Returns: A response containing the RSI values.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.rsi(RSIQuery(ticker: "AAPL", window: 14))
    /// for value in response.results?.values ?? [] {
    ///     let rsi = value.value ?? 0
    ///     if rsi > 70 {
    ///         print("Overbought: \(rsi)")
    ///     } else if rsi < 30 {
    ///         print("Oversold: \(rsi)")
    ///     }
    /// }
    /// ```
    public func rsi(_ query: RSIQuery) async throws -> RSIResponse {
        try await fetch(query)
    }
}
