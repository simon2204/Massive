import Foundation

/// Query parameters for the Tickers endpoint.
///
/// Query all ticker symbols supported by Massive. This endpoint provides a comprehensive
/// list of tickers with filtering and search capabilities.
///
/// Use Cases: Building stock screeners, populating search autocomplete, market exploration.
///
/// ## Example
/// ```swift
/// // Get all stock tickers
/// let query = TickersQuery(market: .stocks, active: true)
///
/// // Search for tickers
/// let query = TickersQuery(search: "Apple", limit: 10)
///
/// // Get tickers by type
/// let query = TickersQuery(type: "ETF", market: .stocks)
/// ```
public struct TickersQuery: APIQuery {
    /// Specify a ticker symbol. Defaults to empty string which queries all tickers.
    public var ticker: Ticker?

    /// Specify the type of the tickers. Find the types via the Ticker Types API.
    public var type: String?

    /// Filter by market type. By default all markets are included.
    public var market: TickerMarket?

    /// Specify the asset's primary exchange Market Identifier Code (MIC) according to ISO 10383.
    public var exchange: String?

    /// Specify the CUSIP code of the asset you want to search for.
    public var cusip: String?

    /// Specify the CIK of the asset you want to search for.
    public var cik: String?

    /// Specify a point in time to retrieve tickers available on that date.
    public var date: String?

    /// Search for terms within the ticker and/or company name.
    public var search: String?

    /// Specify if the tickers returned should be actively traded on the queried date.
    public var active: Bool?

    /// Order results based on the sort field.
    public var order: SortOrder?

    /// Limit the number of results returned. Default is 100, max is 1000.
    public var limit: Int?

    /// Sort field used for ordering.
    public var sort: String?

    public init(
        ticker: Ticker? = nil,
        type: String? = nil,
        market: TickerMarket? = nil,
        exchange: String? = nil,
        cusip: String? = nil,
        cik: String? = nil,
        date: String? = nil,
        search: String? = nil,
        active: Bool? = nil,
        order: SortOrder? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.type = type
        self.market = market
        self.exchange = exchange
        self.cusip = cusip
        self.cik = cik
        self.date = date
        self.search = search
        self.active = active
        self.order = order
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/v3/reference/tickers"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("type", type)
        builder.add("market", market)
        builder.add("exchange", exchange)
        builder.add("cusip", cusip)
        builder.add("cik", cik)
        builder.add("date", date)
        builder.add("search", search)
        builder.add("active", active)
        builder.add("order", order)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
