import Foundation

/// Response from the IPOs endpoint.
public struct IPOsResponse: Codable, Sendable, PaginatedResponse {
    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// The list of IPO events.
    public let results: [IPO]?

    /// URL for fetching the next page.
    public let nextUrl: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case results
        case nextUrl = "next_url"
    }
}

/// An IPO (Initial Public Offering) event.
public struct IPO: Codable, Sendable {
    /// The ticker symbol.
    public let ticker: String?

    /// The name of the issuing company.
    public let issuerName: String?

    /// Description of the security.
    public let securityDescription: String?

    /// Type of security being offered.
    public let securityType: String?

    /// Current status of the IPO.
    public let ipoStatus: String?

    /// Date the IPO was announced.
    public let announcedDate: String?

    /// First trading date.
    public let listingDate: String?

    /// Final issue price per share.
    public let finalIssuePrice: Double?

    /// Highest offer price.
    public let highestOfferPrice: Double?

    /// Lowest offer price.
    public let lowestOfferPrice: Double?

    /// Currency code for prices.
    public let currencyCode: String?

    /// Total size of the offering.
    public let totalOfferSize: Double?

    /// Maximum shares offered.
    public let maxSharesOffered: Int?

    /// Minimum shares offered.
    public let minSharesOffered: Int?

    /// Shares outstanding after IPO.
    public let sharesOutstanding: Int?

    /// Lot size for trading.
    public let lotSize: Int?

    /// Primary exchange for listing.
    public let primaryExchange: String?

    /// US code (CUSIP).
    public let usCode: String?

    /// International Securities Identification Number.
    public let isin: String?

    /// Last updated timestamp.
    public let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case ticker
        case issuerName = "issuer_name"
        case securityDescription = "security_description"
        case securityType = "security_type"
        case ipoStatus = "ipo_status"
        case announcedDate = "announced_date"
        case listingDate = "listing_date"
        case finalIssuePrice = "final_issue_price"
        case highestOfferPrice = "highest_offer_price"
        case lowestOfferPrice = "lowest_offer_price"
        case currencyCode = "currency_code"
        case totalOfferSize = "total_offer_size"
        case maxSharesOffered = "max_shares_offered"
        case minSharesOffered = "min_shares_offered"
        case sharesOutstanding = "shares_outstanding"
        case lotSize = "lot_size"
        case primaryExchange = "primary_exchange"
        case usCode = "us_code"
        case isin
        case lastUpdated = "last_updated"
    }
}
