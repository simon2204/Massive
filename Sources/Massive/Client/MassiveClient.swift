import Fetch
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
/// Methods like `news()` and `bars()` return async sequences that automatically
/// paginate through all results:
///
/// ```swift
/// for try await page in client.news(NewsQuery(ticker: "AAPL")) {
///     for article in page.results ?? [] {
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
        baseURL: URL = massiveAPIEndpoint,
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

    /// The default Massive API endpoint.
    public static let massiveAPIEndpoint = URL(string: "https://api.massive.com")!

    // MARK: - Internal Fetch

    func fetch<Query: APIQuery, Response: Decodable & Sendable>(_ query: Query) async throws -> Response {
        try await fetch(path: query.path, queryItems: query.queryItems)
    }

    func fetch<T: Decodable & Sendable>(
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            throw MassiveError.invalidURL
        }
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw MassiveError.invalidURL
        }

        var request = URLRequest(url: url)
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

        // Sync rate limiter with API response headers
        if let remainingStr = httpResponse.value(forHTTPHeaderField: "X-RateLimit-Remaining"),
           let remaining = Int(remainingStr) {
            rateLimiter?.setAvailableTokens(remaining)
        }

        guard httpResponse.statusCode == 200 else {
            throw MassiveError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        return try decoder.decode(T.self, from: data)
    }

    // MARK: - Pagination Helper

    func paginated<Response: PaginatedResponse, Query: Sendable>(
        query: Query,
        fetch: @escaping @Sendable (Query) async throws -> Response
    ) -> PaginatedSequence<Response, PaginationCursor<Query>> {
        PaginatedSequence(cursor: .initial(query)) { cursor in
            switch cursor {
            case .some(.initial(let q)):
                return try await fetch(q)
            case .some(.next(let url)):
                return try await self.fetch(url: url)
            case .none:
                return try await fetch(query)
            }
        } next: { response in
            response.nextUrl.flatMap { URL(string: $0) }.map { .next($0) }
        }
    }
}
