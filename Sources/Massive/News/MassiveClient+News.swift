import Fetch
import Foundation

extension MassiveClient {
    public func news(_ query: NewsQuery = NewsQuery()) async throws -> NewsResponse {
        try await fetch(path: "/v2/reference/news", queryItems: query.queryItems)
    }

    public func allNews(_ query: NewsQuery = NewsQuery()) -> PaginatedSequence<NewsResponse, PaginationCursor<NewsQuery>> {
        paginated(
            query: query,
            fetch: { try await self.news($0) },
            fetchPage: { try await self.fetch(url: $0) },
            nextURL: { $0.nextUrl.flatMap { URL(string: $0) } }
        )
    }
}
