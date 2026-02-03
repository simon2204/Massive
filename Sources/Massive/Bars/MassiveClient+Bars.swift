import Fetch
import Foundation

extension MassiveClient {
    public func bars(_ query: BarsQuery) async throws -> BarsResponse {
        try await fetch(path: query.pathComponents, queryItems: query.queryItems)
    }

    public func allBars(_ query: BarsQuery) -> PaginatedSequence<BarsResponse, PaginationCursor<BarsQuery>> {
        paginated(
            query: query,
            fetch: { try await self.bars($0) },
            fetchPage: { try await self.fetch(url: $0) },
            nextURL: { $0.nextUrl.flatMap { URL(string: $0) } }
        )
    }
}
