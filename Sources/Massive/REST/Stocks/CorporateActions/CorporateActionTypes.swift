import Foundation

/// IPO status indicating the current phase.
public enum IPOStatus: String, Sendable, CaseIterable {
    case pending
    case new
    case rumors
    case historical
}

/// Split adjustment type classification.
public enum SplitAdjustmentType: String, Sendable, CaseIterable {
    case forwardSplit = "forward_split"
    case reverseSplit = "reverse_split"
    case stockDividend = "stock_dividend"
}

/// Dividend distribution type classification.
public enum DividendDistributionType: String, Sendable, CaseIterable {
    case recurring
    case special
    case supplemental
    case irregular
    case unknown
}

/// Dividend frequency (distributions per year).
public enum DividendFrequency: Int, Sendable, CaseIterable {
    case nonRecurring = 0
    case annual = 1
    case semiAnnual = 2
    case trimester = 3
    case quarterly = 4
    case monthly = 12
    case biMonthly = 24
    case weekly = 52
    case biWeekly = 104
    case daily = 365
}
