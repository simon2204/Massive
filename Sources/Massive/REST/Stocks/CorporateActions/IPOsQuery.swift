import Foundation

/// Query parameters for the IPOs endpoint.
///
/// Get historical and upcoming IPO (Initial Public Offering) data.
///
/// Use Cases: IPO tracking, market research, investment analysis.
///
/// ## Example
/// ```swift
/// // All recent IPOs
/// let query = IPOsQuery()
///
/// // IPOs for a specific ticker
/// let query = IPOsQuery(ticker: "TICKER")
///
/// // Filter by status
/// let query = IPOsQuery(ipoStatus: .pending)
/// ```
public struct IPOsQuery: APIQuery {
    /// The ticker symbol of the IPO.
    public let ticker: Ticker?

    /// Nine-character US code (CUSIP).
    public let usCode: String?

    /// International Securities Identification Number (ISIN).
    public let isin: String?

    /// First trading date for the newly listed entity (YYYY-MM-DD).
    public let listingDate: String?

    /// The current phase of the IPO.
    public let ipoStatus: IPOStatus?

    /// Limit the number of results (default 10, max 1000).
    public let limit: Int?

    /// Sort columns with direction (e.g., "listing_date.desc").
    public let sort: String?

    public init(
        ticker: Ticker? = nil,
        usCode: String? = nil,
        isin: String? = nil,
        listingDate: String? = nil,
        ipoStatus: IPOStatus? = nil,
        limit: Int? = nil,
        sort: String? = nil
    ) {
        self.ticker = ticker
        self.usCode = usCode
        self.isin = isin
        self.listingDate = listingDate
        self.ipoStatus = ipoStatus
        self.limit = limit
        self.sort = sort
    }

    public var path: String {
        "/vX/reference/ipos"
    }

    public var queryItems: [URLQueryItem]? {
        var builder = QueryBuilder()
        builder.add("ticker", ticker)
        builder.add("us_code", usCode)
        builder.add("isin", isin)
        builder.add("listing_date", listingDate)
        builder.add("ipo_status", ipoStatus)
        builder.add("limit", limit)
        builder.add("sort", sort)
        return builder.build()
    }
}
