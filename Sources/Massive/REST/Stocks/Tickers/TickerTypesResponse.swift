import Foundation

/// Response from the Ticker Types endpoint.
public struct TickerTypesResponse: Codable, Sendable {
    /// The total number of results for this request.
    public let count: Int?

    /// A request ID assigned by the server.
    public let requestId: String

    /// The status of this request's response.
    public let status: String

    /// Array of ticker type results.
    public let results: [TickerType]?
}

/// A ticker type definition.
public struct TickerType: Codable, Sendable {
    /// An identifier for a group of similar financial instruments.
    public let assetClass: TickerAssetClass

    /// A code used by Massive to refer to this ticker type.
    public let code: String

    /// A short description of this ticker type.
    public let description: String

    /// An identifier for a geographical location.
    public let locale: TickerLocale
}
