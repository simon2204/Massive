import Foundation

/// Query parameters for the Stock Splits endpoint.
///
/// Get historical stock split data including forward splits, reverse splits, and stock dividends.
///
/// Use Cases: Price adjustment calculations, historical data normalization, corporate action tracking.
///
/// ## Example
/// ```swift
/// // All splits for AAPL
/// let query = SplitsQuery(ticker: "AAPL")
///
/// // Only forward splits
/// let query = SplitsQuery(adjustmentType: .forwardSplit)
///
/// // Splits on a specific date
/// let query = SplitsQuery(executionDate: "2024-01-15")
/// ```
public struct SplitsQuery: APIQuery {
    /// The ticker symbol.
    public var ticker: Ticker?

    /// Date of split execution (YYYY-MM-DD).
    public var executionDate: String?

    /// Type of split adjustment.
    public var adjustmentType: SplitAdjustmentType?

    /// Limit the number of results (default 100, max 5000).
    public var limit: Int?

    /// Sort columns with direction (e.g., "execution_date.desc").
    public var sort: String?

    public init(
        ticker: Ticker? = nil,
        executionDate: String? = nil,
        adjustmentType: SplitAdjustmentType? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.executionDate = executionDate
        self.adjustmentType = adjustmentType
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/stocks/v1/splits"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("execution_date", executionDate)
        builder.add("adjustment_type", adjustmentType)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
