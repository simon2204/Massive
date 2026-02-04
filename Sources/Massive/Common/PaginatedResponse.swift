import Foundation

/// A response that supports pagination via a next URL.
public protocol PaginatedResponse: Decodable, Sendable {
    /// The URL to fetch the next page of results, if available.
    var nextUrl: String? { get }
}

/// Represents the current position in a paginated request sequence.
///
/// Used internally by `PaginatedSequence` to track whether to use the initial query
/// or follow a next page URL.
public enum PaginationCursor<Query: Sendable>: Sendable {
    /// The initial query to start pagination.
    case initial(Query)
    /// A URL to fetch the next page of results.
    case next(URL)
}
