import Foundation

/// Query parameters for the Market Holidays endpoint.
///
/// Get upcoming market holidays and their status.
///
/// Use Cases: Trading schedule adjustments, holiday calendars, user notifications.
///
/// ## Example
/// ```swift
/// let holidays = try await client.marketHolidays(MarketHolidaysQuery())
/// for holiday in holidays {
///     print("\(holiday.name ?? ""): \(holiday.date ?? "")")
/// }
/// ```
public struct MarketHolidaysQuery: APIQuery {
    public init() {}

    public var path: String {
        "/v1/marketstatus/upcoming"
    }

    public var queryItems: [URLQueryItem]? {
        nil
    }
}
