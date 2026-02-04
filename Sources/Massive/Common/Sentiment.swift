import Foundation

/// Sentiment classification for news articles and insights.
public enum Sentiment: String, Sendable, Codable, CaseIterable {
    /// Positive sentiment.
    case positive
    /// Negative sentiment.
    case negative
    /// Neutral sentiment.
    case neutral
    /// Unknown or unrecognized sentiment value.
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = Sentiment(rawValue: value) ?? .unknown
    }
}
