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
    public var path: String { "/v2/reference/news" }

    /// Case-sensitive ticker symbol (e.g., "AAPL" for Apple Inc.).
    public var ticker: String?

    /// Return results published on, before, or after this date.
    public var publishedUtc: String?

    /// Search by ticker greater than or equal to this value.
    public var tickerGte: String?

    /// Search by ticker greater than this value.
    public var tickerGt: String?

    /// Search by ticker less than or equal to this value.
    public var tickerLte: String?

    /// Search by ticker less than this value.
    public var tickerLt: String?

    /// Return results published on or after this date.
    public var publishedUtcGte: String?

    /// Return results published after this date.
    public var publishedUtcGt: String?

    /// Return results published on or before this date.
    public var publishedUtcLte: String?

    /// Return results published before this date.
    public var publishedUtcLt: String?

    /// Order results based on the `sort` field.
    public var order: Order?

    /// Limit the number of results returned. Default is 10, max is 1000.
    public var limit: Int?

    /// Sort field used for ordering.
    public var sort: String?

    /// Order direction for results.
    public enum Order: String, Sendable {
        /// Ascending order.
        case asc
        /// Descending order.
        case desc
    }

    public init(
        ticker: String? = nil,
        publishedUtc: String? = nil,
        tickerGte: String? = nil,
        tickerGt: String? = nil,
        tickerLte: String? = nil,
        tickerLt: String? = nil,
        publishedUtcGte: String? = nil,
        publishedUtcGt: String? = nil,
        publishedUtcLte: String? = nil,
        publishedUtcLt: String? = nil,
        order: Order? = nil,
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

    public var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = []

        if let ticker { items.append(URLQueryItem(name: "ticker", value: ticker)) }
        if let publishedUtc { items.append(URLQueryItem(name: "published_utc", value: publishedUtc)) }
        if let tickerGte { items.append(URLQueryItem(name: "ticker.gte", value: tickerGte)) }
        if let tickerGt { items.append(URLQueryItem(name: "ticker.gt", value: tickerGt)) }
        if let tickerLte { items.append(URLQueryItem(name: "ticker.lte", value: tickerLte)) }
        if let tickerLt { items.append(URLQueryItem(name: "ticker.lt", value: tickerLt)) }
        if let publishedUtcGte { items.append(URLQueryItem(name: "published_utc.gte", value: publishedUtcGte)) }
        if let publishedUtcGt { items.append(URLQueryItem(name: "published_utc.gt", value: publishedUtcGt)) }
        if let publishedUtcLte { items.append(URLQueryItem(name: "published_utc.lte", value: publishedUtcLte)) }
        if let publishedUtcLt { items.append(URLQueryItem(name: "published_utc.lt", value: publishedUtcLt)) }
        if let order { items.append(URLQueryItem(name: "order", value: order.rawValue)) }
        if let limit { items.append(URLQueryItem(name: "limit", value: String(limit))) }
        if let sort { items.append(URLQueryItem(name: "sort", value: sort)) }

        return items.isEmpty ? nil : items
    }
}
