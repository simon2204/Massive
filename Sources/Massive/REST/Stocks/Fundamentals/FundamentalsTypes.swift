import Foundation

/// Reporting timeframe for financial statements.
public enum FinancialTimeframe: String, Sendable, CaseIterable {
    case quarterly
    case annual
    case trailingTwelveMonths = "trailing_twelve_months"
}

/// A financial data point with value, unit, and label.
public struct FinancialValue: Codable, Sendable {
    /// The numeric value.
    public let value: Double?

    /// The unit of measurement (e.g., "USD").
    public let unit: String?

    /// Human-readable label.
    public let label: String?

    /// The order for display purposes.
    public let order: Int?
}
