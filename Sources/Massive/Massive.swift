import Fetch
import Foundation

public struct MassiveClient: Sendable {
    let apiKey: String
    let baseURL: URL
    let session: URLSession
    let rateLimiter: RateLimiter?
    let retry: Retry

    private let decoder = JSONDataDecoder()

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

public enum PaginationCursor<Query: Sendable>: Sendable {
    case initial(Query)
    case next(URL)
}

// MARK: - Errors

public enum MassiveError: Error, Sendable {
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
}
