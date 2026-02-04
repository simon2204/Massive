import Foundation

/// Errors that can occur when interacting with the Massive API.
public enum MassiveError: Error, Sendable {
    /// The server returned an invalid or unexpected response format.
    case invalidResponse
    /// The URL could not be constructed from the provided components.
    case invalidURL
    /// The server returned an HTTP error status code.
    /// - Parameters:
    ///   - statusCode: The HTTP status code (e.g., 401, 404, 500).
    ///   - data: The response body data, which may contain error details.
    case httpError(statusCode: Int, data: Data)
}
