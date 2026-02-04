import Foundation

/// Query parameters for the News endpoint.
///
/// Retrieve the most recent news articles related to a specified ticker, along with summaries,
/// source details, and sentiment analysis. This endpoint consolidates relevant financial news
/// in one place, extracting associated tickers, assigning sentiment, and providing direct links
/// to the original sources.
///
/// Use Cases: Market sentiment analysis, investment research, automated monitoring,
/// and portfolio strategy refinement.
///
/// ## Example
/// ```swift
/// // News for a specific ticker
/// let query = NewsQuery(ticker: "AAPL", limit: 10)
///
/// // News from a date range
/// let query = NewsQuery(
///     publishedUtcGte: "2024-01-01",
///     publishedUtcLte: "2024-01-31",
///     order: .desc
/// )
/// ```
public struct NewsQuery: APIQuery {
    /// The ticker symbol (e.g., "AAPL" for Apple Inc.).
    public var ticker: Ticker?

    /// Return results published on, before, or after this date.
    public var publishedUtc: String?

    /// Search by ticker greater than or equal to this value.
    public var tickerGte: Ticker?

    /// Search by ticker greater than this value.
    public var tickerGt: Ticker?

    /// Search by ticker less than or equal to this value.
    public var tickerLte: Ticker?

    /// Search by ticker less than this value.
    public var tickerLt: Ticker?

    /// Return results published on or after this date.
    public var publishedUtcGte: String?

    /// Return results published after this date.
    public var publishedUtcGt: String?

    /// Return results published on or before this date.
    public var publishedUtcLte: String?

    /// Return results published before this date.
    public var publishedUtcLt: String?

    /// Order results based on the `sort` field.
    public var order: SortOrder?

    /// Limit the number of results returned. Default is 10, max is 1000.
    public var limit: Int?

    /// Sort field used for ordering.
    public var sort: String?

    public init(
        ticker: Ticker? = nil,
        publishedUtc: String? = nil,
        tickerGte: Ticker? = nil,
        tickerGt: Ticker? = nil,
        tickerLte: Ticker? = nil,
        tickerLt: Ticker? = nil,
        publishedUtcGte: String? = nil,
        publishedUtcGt: String? = nil,
        publishedUtcLte: String? = nil,
        publishedUtcLt: String? = nil,
        order: SortOrder? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.publishedUtc = publishedUtc
        self.tickerGte = tickerGte
        self.tickerGt = tickerGt
        self.tickerLte = tickerLte
        self.tickerLt = tickerLt
        self.publishedUtcGte = publishedUtcGte
        self.publishedUtcGt = publishedUtcGt
        self.publishedUtcLte = publishedUtcLte
        self.publishedUtcLt = publishedUtcLt
        self.order = order
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/v2/reference/news"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("published_utc", publishedUtc)
        builder.add("ticker.gte", tickerGte)
        builder.add("ticker.gt", tickerGt)
        builder.add("ticker.lte", tickerLte)
        builder.add("ticker.lt", tickerLt)
        builder.add("published_utc.gte", publishedUtcGte)
        builder.add("published_utc.gt", publishedUtcGt)
        builder.add("published_utc.lte", publishedUtcLte)
        builder.add("published_utc.lt", publishedUtcLt)
        builder.add("order", order)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
