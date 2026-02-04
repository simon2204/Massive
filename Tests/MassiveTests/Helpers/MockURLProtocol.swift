import Foundation
import Synchronization
import Fetch
@testable import Massive

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Mock URLProtocol with Request-Based Routing

/// A thread-safe mock URLProtocol that routes responses based on a custom header.
/// Each test creates a unique session ID, allowing parallel test execution without race conditions.
final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    
    /// The header name used to identify which mock response to return
    static let sessionIdHeader = "X-Mock-Session-Id"
    
    /// Thread-safe storage for mock handlers using Swift 6 Mutex
    private static let handlers = Mutex<[String: MockHandler]>([:])
    
    /// A handler that determines how to respond to a request
    struct MockHandler: Sendable {
        let response: @Sendable (URLRequest) -> MockResult
    }
    
    /// The result of a mock handler
    enum MockResult: Sendable {
        case success(Data, HTTPURLResponse)
        case failure(Error)
    }
    
    // MARK: - Registration API
    
    /// Register a handler for a specific session ID
    static func register(sessionId: String, handler: @escaping @Sendable (URLRequest) -> MockResult) {
        handlers.withLock { $0[sessionId] = MockHandler(response: handler) }
    }
    
    /// Register a simple response for a session ID
    static func register(
        sessionId: String,
        data: Data,
        statusCode: Int = 200,
        headers: [String: String]? = nil
    ) {
        register(sessionId: sessionId) { request in
            let url = request.url ?? URL(string: "https://mock.test")!
            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: headers
            )!
            return .success(data, response)
        }
    }
    
    /// Register an error for a session ID
    static func register(sessionId: String, error: Error) {
        register(sessionId: sessionId) { _ in
            return .failure(error)
        }
    }
    
    /// Unregister a handler
    static func unregister(sessionId: String) {
        _ = handlers.withLock { $0.removeValue(forKey: sessionId) }
    }
    
    /// Clear all handlers
    static func reset() {
        handlers.withLock { $0.removeAll() }
    }
    
    // MARK: - URLProtocol Implementation
    
    override class func canInit(with request: URLRequest) -> Bool {
        guard let sessionId = request.value(forHTTPHeaderField: sessionIdHeader) else {
            return false
        }
        return handlers.withLock { $0[sessionId] != nil }
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let sessionId = request.value(forHTTPHeaderField: Self.sessionIdHeader) else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        let handler = Self.handlers.withLock { $0[sessionId] }
        
        guard let handler else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        let result = handler.response(request)
        
        switch result {
        case .success(let data, let response):
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

// MARK: - Mock Session

/// A test session that automatically manages mock registration and cleanup.
/// Each instance gets a unique session ID for parallel test isolation.
final class MockSession: Sendable {
    let sessionId: String
    let urlSession: URLSession
    
    init() {
        self.sessionId = UUID().uuidString
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        config.httpAdditionalHeaders = [MockURLProtocol.sessionIdHeader: sessionId]
        self.urlSession = URLSession(configuration: config)
    }
    
    deinit {
        MockURLProtocol.unregister(sessionId: sessionId)
    }
    
    /// Register a response for this session
    func register(data: Data, statusCode: Int = 200, headers: [String: String]? = nil) {
        MockURLProtocol.register(sessionId: sessionId, data: data, statusCode: statusCode, headers: headers)
    }
    
    /// Register an error for this session
    func register(error: Error) {
        MockURLProtocol.register(sessionId: sessionId, error: error)
    }
}

// MARK: - Test Client Factories

func makeTestClient(session: MockSession) -> MassiveClient {
    MassiveClient(
        apiKey: "test-key",
        session: session.urlSession,
        retry: Retry(maxAttempts: 1)
    )
}

func makeTestS3Client(session: MockSession) -> S3Client {
    S3Client(
        endpoint: URL(string: "https://files.massive.com")!,
        bucket: "flatfiles",
        credentials: S3Credentials(
            accessKeyId: "AKIAIOSFODNN7EXAMPLE",
            secretAccessKey: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        ),
        session: session.urlSession
    )
}
