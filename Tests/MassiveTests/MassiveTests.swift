import Foundation
import Testing
import Fetch
@testable import Massive

// MARK: - Mock URLSession

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var mockResponse: (Data, HTTPURLResponse)?
    nonisolated(unsafe) static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let (data, response) = Self.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

func makeMockSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

func makeTestClient() -> MassiveClient {
    MassiveClient(
        apiKey: "test-key",
        session: makeMockSession(),
        retry: Retry(maxAttempts: 1)
    )
}

// MARK: - All Tests (serialized to avoid shared mock state conflicts)

@Suite("MassiveClient", .serialized)
struct MassiveClientTests {

    // MARK: - News

    let mockNewsResponse = """
    {
        "count": 2,
        "request_id": "test-123",
        "results": [
            {
                "id": "article-1",
                "title": "Apple announces new iPhone",
                "article_url": "https://example.com/article1",
                "published_utc": "2024-01-15T10:00:00Z",
                "publisher": { "name": "Tech News" },
                "tickers": ["AAPL"]
            },
            {
                "id": "article-2",
                "title": "Apple stock rises",
                "article_url": "https://example.com/article2",
                "published_utc": "2024-01-15T11:00:00Z",
                "publisher": { "name": "Finance Daily" },
                "tickers": ["AAPL"]
            }
        ],
        "status": "OK"
    }
    """.data(using: .utf8)!

    @Test("Fetch news successfully")
    func fetchNews() async throws {
        MockURLProtocol.mockResponse = (
            mockNewsResponse,
            HTTPURLResponse(url: URL(string: "https://api.massive.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        MockURLProtocol.mockError = nil

        let client = makeTestClient()
        let response = try await client.news(NewsQuery(ticker: "AAPL"))

        #expect(response.count == 2)
        #expect(response.results.count == 2)
        #expect(response.results[0].title == "Apple announces new iPhone")
        #expect(response.results[1].publisher.name == "Finance Daily")
    }

    @Test("News query builds correct URL parameters")
    func newsQueryParameters() {
        let query = NewsQuery(
            ticker: "AAPL",
            publishedUtcGte: "2024-01-01",
            order: .desc,
            limit: 50
        )

        let items = query.queryItems
        #expect(items.contains { $0.name == "ticker" && $0.value == "AAPL" })
        #expect(items.contains { $0.name == "published_utc.gte" && $0.value == "2024-01-01" })
        #expect(items.contains { $0.name == "limit" && $0.value == "50" })
        #expect(items.contains { $0.name == "order" && $0.value == "desc" })
    }

    // MARK: - Bars

    let mockBarsResponse = """
    {
        "ticker": "AAPL",
        "adjusted": true,
        "query_count": 5,
        "request_id": "test-456",
        "results_count": 2,
        "status": "OK",
        "results": [
            { "o": 150.0, "h": 155.0, "l": 149.0, "c": 154.0, "v": 1000000, "t": 1704067200000 },
            { "o": 154.0, "h": 158.0, "l": 153.0, "c": 157.0, "v": 1200000, "t": 1704153600000 }
        ]
    }
    """.data(using: .utf8)!

    @Test("Fetch bars successfully")
    func fetchBars() async throws {
        MockURLProtocol.mockResponse = (
            mockBarsResponse,
            HTTPURLResponse(url: URL(string: "https://api.massive.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        )
        MockURLProtocol.mockError = nil

        let client = makeTestClient()
        let response = try await client.bars(BarsQuery(
            ticker: "AAPL",
            from: "2024-01-01",
            to: "2024-01-10"
        ))

        #expect(response.ticker == "AAPL")
        #expect(response.adjusted == true)
        #expect(response.resultsCount == 2)
        #expect(response.results?.count == 2)
        #expect(response.results?[0].o == 150.0)
        #expect(response.results?[0].c == 154.0)
    }

    @Test("Bars query builds correct path")
    func barsQueryPath() {
        let query = BarsQuery(
            ticker: "AAPL",
            multiplier: 5,
            timespan: .minute,
            from: "2024-01-01",
            to: "2024-01-02"
        )

        #expect(query.pathComponents == "/v2/aggs/ticker/AAPL/range/5/minute/2024-01-01/2024-01-02")
    }

    @Test("Bars query parameters")
    func barsQueryParameters() {
        let query = BarsQuery(
            ticker: "AAPL",
            from: "2024-01-01",
            to: "2024-01-02",
            adjusted: false,
            sort: .asc,
            limit: 1000
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "adjusted" && $0.value == "false" })
        #expect(items.contains { $0.name == "sort" && $0.value == "asc" })
        #expect(items.contains { $0.name == "limit" && $0.value == "1000" })
    }

    // MARK: - Errors

    @Test("HTTP error returns correct status code")
    func httpError() async throws {
        MockURLProtocol.mockResponse = (
            "Unauthorized".data(using: .utf8)!,
            HTTPURLResponse(url: URL(string: "https://api.massive.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
        )
        MockURLProtocol.mockError = nil

        let client = makeTestClient()

        do {
            _ = try await client.news()
            #expect(Bool(false), "Should have thrown an error")
        } catch let error as MassiveError {
            if case .httpError(let statusCode, _) = error {
                #expect(statusCode == 401)
            } else {
                #expect(Bool(false), "Wrong error type")
            }
        }
    }
}
