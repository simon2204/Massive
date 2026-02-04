import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A client for interacting with S3-compatible storage.
///
/// `S3Client` provides methods for listing and downloading objects from S3-compatible
/// endpoints like Massive Flat Files.
///
/// ## Usage
///
/// ```swift
/// let client = S3Client(
///     endpoint: URL(string: "https://files.massive.com")!,
///     bucket: "flatfiles",
///     credentials: S3Credentials(accessKeyId: "...", secretAccessKey: "...")
/// )
///
/// // List objects
/// let result = try await client.list(prefix: "us_stocks_sip/trades_v1/2025/")
/// for object in result.objects {
///     print("\(object.key) - \(object.size) bytes")
/// }
///
/// // Download an object
/// let data = try await client.download(key: "us_stocks_sip/trades_v1/2025/11/2025-11-05.csv.gz")
/// ```
public struct S3Client: Sendable {
    /// The S3-compatible endpoint URL.
    public let endpoint: URL

    /// The bucket name.
    public let bucket: String

    /// The credentials for authentication.
    public let credentials: S3Credentials

    /// The URLSession to use for requests.
    public let session: URLSession

    /// The AWS region (default: "us-east-1").
    public let region: String

    private let signer: S3Signer

    /// Creates a new S3 client.
    ///
    /// - Parameters:
    ///   - endpoint: The S3-compatible endpoint URL (e.g., `https://files.massive.com`).
    ///   - bucket: The bucket name (e.g., `flatfiles`).
    ///   - credentials: AWS-style credentials for authentication.
    ///   - session: The URLSession to use (default: `.shared`).
    ///   - region: The AWS region (default: `us-east-1`).
    public init(
        endpoint: URL,
        bucket: String,
        credentials: S3Credentials,
        session: URLSession = .shared,
        region: String = "us-east-1"
    ) {
        self.endpoint = endpoint
        self.bucket = bucket
        self.credentials = credentials
        self.session = session
        self.region = region
        self.signer = S3Signer(credentials: credentials, region: region)
    }

    // MARK: - List Objects

    /// Lists objects in the bucket.
    ///
    /// - Parameters:
    ///   - prefix: Filter objects by prefix (e.g., `us_stocks_sip/trades_v1/2025/`).
    ///   - maxKeys: Maximum number of objects to return (default: 1000).
    ///   - continuationToken: Token for pagination (from previous `S3ListResult.nextContinuationToken`).
    /// - Returns: A list result containing objects and pagination info.
    public func list(
        prefix: String? = nil,
        maxKeys: Int = 1000,
        continuationToken: String? = nil
    ) async throws -> S3ListResult {
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        components.path = "/\(bucket)"

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "list-type", value: "2"),
            URLQueryItem(name: "max-keys", value: String(maxKeys))
        ]

        if let prefix {
            queryItems.append(URLQueryItem(name: "prefix", value: prefix))
        }

        if let continuationToken {
            queryItems.append(URLQueryItem(name: "continuation-token", value: continuationToken))
        }

        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let (data, response) = try await session.data(for: signedRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw S3Error.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw S3ErrorParser().parse(data, statusCode: httpResponse.statusCode)
        }

        return try S3ListResultParser().parse(data)
    }

    /// Lists all objects matching a prefix, automatically handling pagination.
    ///
    /// - Parameters:
    ///   - prefix: Filter objects by prefix.
    ///   - maxKeys: Maximum objects per page (default: 1000).
    /// - Returns: An async sequence of list results.
    public func listAll(
        prefix: String? = nil,
        maxKeys: Int = 1000
    ) -> AsyncThrowingStream<S3ListResult, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var token: String? = nil
                repeat {
                    do {
                        let result = try await list(
                            prefix: prefix,
                            maxKeys: maxKeys,
                            continuationToken: token
                        )
                        continuation.yield(result)
                        token = result.isTruncated ? result.nextContinuationToken : nil
                    } catch {
                        continuation.finish(throwing: error)
                        return
                    }
                } while token != nil
                continuation.finish()
            }
        }
    }

    // MARK: - Download Objects

    /// Downloads an object and returns its data.
    ///
    /// - Parameter key: The object key (path/filename).
    /// - Returns: The object data.
    public func download(key: String) async throws -> Data {
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        components.path = "/\(bucket)/\(key)"

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let (data, response) = try await session.data(for: signedRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw S3Error.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            return data
        case 404:
            throw S3Error.notFound(key: key)
        default:
            throw S3ErrorParser().parse(data, statusCode: httpResponse.statusCode)
        }
    }

    /// Downloads an object to a file.
    ///
    /// - Parameters:
    ///   - key: The object key (path/filename).
    ///   - destination: The local file URL to save to.
    public func download(key: String, to destination: URL) async throws {
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        components.path = "/\(bucket)/\(key)"

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let (tempURL, response) = try await session.download(for: signedRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw S3Error.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            try FileManager.default.moveItem(at: tempURL, to: destination)
        case 404:
            throw S3Error.notFound(key: key)
        default:
            let data = try Data(contentsOf: tempURL)
            throw S3ErrorParser().parse(data, statusCode: httpResponse.statusCode)
        }
    }

    // MARK: - Head Object (Check Existence)

    /// Checks if an object exists and returns its metadata.
    ///
    /// - Parameter key: The object key (path/filename).
    /// - Returns: The object metadata, or `nil` if not found.
    public func head(key: String) async throws -> S3ObjectMetadata? {
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        components.path = "/\(bucket)/\(key)"

        var request = URLRequest(url: components.url!)
        request.httpMethod = "HEAD"

        let signedRequest = signer.sign(request)
        let (_, response) = try await session.data(for: signedRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw S3Error.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length")
                .flatMap { Int($0) } ?? 0
            let lastModified = httpResponse.value(forHTTPHeaderField: "Last-Modified")
                .flatMap { try? Self.httpDateStrategy.parse($0) }
            let etag = httpResponse.value(forHTTPHeaderField: "ETag")?
                .replacing("\"", with: "")
            let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type")

            return S3ObjectMetadata(
                key: key,
                size: contentLength,
                lastModified: lastModified,
                etag: etag,
                contentType: contentType
            )
        case 404:
            return nil
        default:
            throw S3Error.httpError(statusCode: httpResponse.statusCode, message: nil)
        }
    }

    // MARK: - Private

    /// HTTP date format strategy (RFC 7231): "Tue, 15 Nov 1994 08:12:31 GMT"
    private static let httpDateStrategy = Date.VerbatimFormatStyle(
        format: "\(weekday: .abbreviated), \(day: .twoDigits) \(month: .abbreviated) \(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits) \(timeZone: .identifier(.short))",
        timeZone: .gmt,
        calendar: Calendar(identifier: .iso8601)
    ).parseStrategy
}

/// Metadata for an S3 object (from HEAD request).
public struct S3ObjectMetadata: Sendable {
    /// The object key.
    public let key: String
    /// The size in bytes.
    public let size: Int
    /// The last modified date.
    public let lastModified: Date?
    /// The ETag.
    public let etag: String?
    /// The content type.
    public let contentType: String?
}
