import Foundation

/// A query that can be executed against the Massive API.
public protocol APIQuery: Sendable {
    /// The API endpoint path.
    var path: String { get }
    /// The query parameters.
    var queryItems: [URLQueryItem]? { get }
}
