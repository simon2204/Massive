import Foundation

/// A market holiday entry.
public struct MarketHoliday: Codable, Sendable {
    /// The holiday date.
    public let date: String?

    /// The name of the holiday.
    public let name: String?

    /// Which market/exchange this applies to.
    public let exchange: String?

    /// Market status on this holiday.
    public let status: String?

    /// Market opening time (if not fully closed).
    public let open: String?

    /// Market closing time (if not fully closed).
    public let close: String?
}

/// Type alias for the holidays response (array of holidays).
public typealias MarketHolidaysResponse = [MarketHoliday]
