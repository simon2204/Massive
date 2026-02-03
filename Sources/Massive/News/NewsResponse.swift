import Foundation

/// Response from the News endpoint.
public struct NewsResponse: Codable, Sendable {
    /// The total number of results for this request.
    public let count: Int

    /// If present, this value can be used to fetch the next page of data.
    public let nextUrl: String?

    /// A request ID assigned by the server.
    public let requestId: String

    /// An array of news article results.
    public let results: [NewsArticle]

    /// The status of this request's response.
    public let status: String
}

/// A news article with metadata, sentiment analysis, and source details.
public struct NewsArticle: Codable, Sendable, Identifiable {
    /// Unique identifier for the article.
    public let id: String

    /// The mobile friendly Accelerated Mobile Page (AMP) URL.
    public let ampUrl: String?

    /// A link to the news article.
    public let articleUrl: String

    /// The article's author.
    public let author: String?

    /// A description of the article.
    public let description: String?

    /// The article's image URL.
    public let imageUrl: String?

    /// The insights related to the article, including sentiment analysis.
    public let insights: [NewsInsight]?

    /// The keywords associated with the article (varies by publishing source).
    public let keywords: [String]?

    /// The UTC date and time when the article was published (RFC3339 format).
    public let publishedUtc: String

    /// Details about the source of the news article.
    public let publisher: NewsPublisher

    /// The ticker symbols associated with the article.
    public let tickers: [String]?

    /// The title of the news article.
    public let title: String
}

/// Sentiment analysis insight for a ticker mentioned in an article.
public struct NewsInsight: Codable, Sendable {
    /// The sentiment classification (e.g., "positive", "negative", "neutral").
    public let sentiment: String

    /// The reasoning behind the sentiment classification.
    public let sentimentReasoning: String

    /// The ticker symbol this insight relates to.
    public let ticker: String
}

/// Details about the publisher of a news article.
public struct NewsPublisher: Codable, Sendable {
    /// URL to the publisher's favicon.
    public let faviconUrl: String?

    /// URL to the publisher's homepage.
    public let homepageUrl: String?

    /// URL to the publisher's logo.
    public let logoUrl: String?

    /// The name of the publisher.
    public let name: String
}
