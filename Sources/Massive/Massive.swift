import Fetch
import Foundation

/// A client for interacting with the Massive API.
///
/// `MassiveClient` provides methods for fetching market news and historical bar data.
/// It handles authentication, rate limiting, and automatic retries.
///
/// ## Usage
///
/// ```swift
/// let client = MassiveClient(apiKey: "your-api-key")
///
/// // Fetch news
/// let news = try await client.news(NewsQuery(ticker: "AAPL"))
///
/// // Fetch bars
/// let bars = try await client.bars(BarsQuery(
///     ticker: "AAPL",
///     from: "2024-01-01",
///     to: "2024-01-31"
/// ))
/// ```
///
/// ## Pagination
///
/// For endpoints that return paginated results, use the `allNews` or `allBars` methods
/// to automatically iterate through all pages:
///
/// ```swift
/// for try await page in client.allNews(NewsQuery(ticker: "AAPL")) {
///     for article in page.results {
///         print(article.title)
///     }
/// }
/// ```
public struct MassiveClient: Sendable {
    let apiKey: String
    let baseURL: URL
    let session: URLSession
    let rateLimiter: RateLimiter?
    let retry: Retry

    private let decoder = JSONDataDecoder()

    /// Creates a new Massive API client.
    ///
    /// - Parameters:
    ///   - apiKey: Your Massive API key for authentication.
    ///   - baseURL: The base URL for API requests. Defaults to the Massive API endpoint.
    ///   - session: The URLSession to use for network requests. Defaults to `.shared`.
    ///   - rateLimiter: Optional rate limiter to control request frequency.
    ///   - retry: Retry configuration for failed requests. Defaults to 3 attempts with 1 second base delay.
    public init(
        apiKey: String,
        baseURL: URL = URL(string: "https://api.massive.com")!,
        session: URLSession = .shared,
        rateLimiter: RateLimiter? = nil,
        retry: Retry = Retry(baseDelay: .seconds(1), maxAttempts: 3)
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.session = session
        self.rateLimiter = rateLimiter
        self.retry = retry
    }

    // MARK: - Internal Fetch

    func fetch<T: Decodable & Sendable>(
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.path = path
        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        return try await execute(request)
    }

    func fetch<T: Decodable & Sendable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        return try await execute(request)
    }

    private func execute<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        try await rateLimiter?.acquire()

        let (data, response) = try await retry.execute {
            try await session.data(for: request)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MassiveError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw MassiveError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Pagination Helper

    func paginated<Response: Decodable & Sendable, Query>(
        query: Query,
        fetch: @escaping @Sendable (Query) async throws -> Response,
        fetchPage: @escaping @Sendable (URL) async throws -> Response,
        nextURL: @escaping @Sendable (Response) -> URL?
    ) -> PaginatedSequence<Response, PaginationCursor<Query>> {
        PaginatedSequence(cursor: .initial(query)) { cursor in
            switch cursor {
            case .some(.initial(let q)):
                return try await fetch(q)
            case .some(.next(let url)):
                return try await fetchPage(url)
            case .none:
                return try await fetch(query)
            }
        } next: { response in
            nextURL(response).map { .next($0) }
        }
    }
}

// MARK: - Pagination Cursor

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

// MARK: - Errors

/// Errors that can occur when interacting with the Massive API.
public enum MassiveError: Error, Sendable {
    /// The server returned an invalid or unexpected response format.
    case invalidResponse
    /// The server returned an HTTP error status code.
    /// - Parameters:
    ///   - statusCode: The HTTP status code (e.g., 401, 404, 500).
    ///   - data: The response body data, which may contain error details.
    case httpError(statusCode: Int, data: Data)
}
