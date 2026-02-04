import Foundation

/// Sort order for API results.
///
/// Used by multiple endpoints to control the ordering of results.
public enum SortOrder: String, Sendable, CaseIterable {
    /// Ascending order (oldest/smallest first).
    case asc
    /// Descending order (newest/largest first).
    case desc
}
