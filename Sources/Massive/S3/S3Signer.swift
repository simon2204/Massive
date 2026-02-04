import Crypto
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// AWS Signature Version 4 signer for S3 requests.
///
/// This implementation follows the AWS Signature Version 4 signing process:
/// 1. Create a canonical request
/// 2. Create a string to sign
/// 3. Calculate the signing key
/// 4. Calculate the signature
struct S3Signer: Sendable {
    let credentials: S3Credentials
    let region: String
    let service: String

    /// Creates a new S3 signer.
    ///
    /// - Parameters:
    ///   - credentials: AWS-style credentials (Access Key ID + Secret Access Key).
    ///   - region: AWS region (default: "us-east-1" for S3-compatible endpoints).
    ///   - service: AWS service name (default: "s3").
    init(credentials: S3Credentials, region: String = "us-east-1", service: String = "s3") {
        self.credentials = credentials
        self.region = region
        self.service = service
    }

    /// Signs a URLRequest using AWS Signature Version 4.
    ///
    /// - Parameters:
    ///   - request: The request to sign.
    ///   - date: The date to use for signing (default: now).
    /// - Returns: A new URLRequest with authentication headers added.
    func sign(_ request: URLRequest, date: Date = Date()) -> URLRequest {
        var request = request

        guard let url = request.url, let host = url.host else {
            return request
        }

        // Format dates (AWS requires specific formats in UTC)
        let amzDate = date.formatted(Self.amzDateFormat)
        let dateStamp = date.formatted(Self.dateStampFormat)

        // Calculate payload hash (empty for GET requests)
        let payload = request.httpBody ?? Data()
        let payloadHash = Self.sha256Hex(payload)

        // Set required headers
        request.setValue(host, forHTTPHeaderField: "Host")
        request.setValue(amzDate, forHTTPHeaderField: "x-amz-date")
        request.setValue(payloadHash, forHTTPHeaderField: "x-amz-content-sha256")

        // Build canonical request
        let method = request.httpMethod ?? "GET"
        let canonicalURI = Self.uriEncode(url.path.isEmpty ? "/" : url.path, encodeSlash: false)
        let canonicalQueryString = Self.canonicalQueryString(from: url)

        // Collect and sort headers
        let headersToSign = ["host", "x-amz-content-sha256", "x-amz-date"]
        let canonicalHeaders = headersToSign
            .map { "\($0):\(request.value(forHTTPHeaderField: $0) ?? "")" }
            .joined(separator: "\n") + "\n"
        let signedHeaders = headersToSign.joined(separator: ";")

        let canonicalRequest = [
            method,
            canonicalURI,
            canonicalQueryString,
            canonicalHeaders,
            signedHeaders,
            payloadHash
        ].joined(separator: "\n")

        // Create string to sign
        let credentialScope = "\(dateStamp)/\(region)/\(service)/aws4_request"
        let stringToSign = [
            "AWS4-HMAC-SHA256",
            amzDate,
            credentialScope,
            Self.sha256Hex(Data(canonicalRequest.utf8))
        ].joined(separator: "\n")

        // Derive signing key
        let signingKey = deriveSigningKey(dateStamp: dateStamp)

        // Calculate signature
        let signature = Self.hmacSHA256(key: signingKey, data: Data(stringToSign.utf8)).hexString

        // Build Authorization header
        let authorization = "AWS4-HMAC-SHA256 Credential=\(credentials.accessKeyId)/\(credentialScope),SignedHeaders=\(signedHeaders),Signature=\(signature)"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")

        return request
    }

    // MARK: - Private Helpers

    /// Derives the signing key using successive HMAC operations.
    private func deriveSigningKey(dateStamp: String) -> Data {
        let kDate = Self.hmacSHA256(
            key: Data("AWS4\(credentials.secretAccessKey)".utf8),
            data: Data(dateStamp.utf8)
        )
        let kRegion = Self.hmacSHA256(key: kDate, data: Data(region.utf8))
        let kService = Self.hmacSHA256(key: kRegion, data: Data(service.utf8))
        let kSigning = Self.hmacSHA256(key: kService, data: Data("aws4_request".utf8))
        return kSigning
    }

    // MARK: - Cryptographic Functions

    /// Computes SHA256 hash and returns hex-encoded string.
    static func sha256Hex(_ data: Data) -> String {
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    /// Computes HMAC-SHA256.
    static func hmacSHA256(key: Data, data: Data) -> Data {
        let symmetricKey = SymmetricKey(data: key)
        let mac = HMAC<SHA256>.authenticationCode(for: data, using: symmetricKey)
        return Data(mac)
    }

    // MARK: - URI Encoding

    /// AWS-compliant URI encoding.
    ///
    /// Encodes all characters except: A-Z, a-z, 0-9, -, ., _, ~
    /// Optionally preserves forward slashes.
    static func uriEncode(_ string: String, encodeSlash: Bool = true) -> String {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~")
        if !encodeSlash {
            allowed.insert("/")
        }

        // Percent-encode, ensuring uppercase hex digits
        return string.addingPercentEncoding(withAllowedCharacters: allowed)?
            .replacingOccurrences(of: "+", with: "%2B") ?? string
    }

    /// Creates a canonical query string from URL query items.
    static func canonicalQueryString(from url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems, !queryItems.isEmpty else {
            return ""
        }

        return queryItems
            .sorted { $0.name < $1.name }
            .map { "\(uriEncode($0.name))=\(uriEncode($0.value ?? ""))" }
            .joined(separator: "&")
    }

    // MARK: - Date Formats

    /// Format for x-amz-date header (e.g., "20130524T000000Z").
    private static let amzDateFormat = Date.VerbatimFormatStyle(
        format: "\(year: .defaultDigits)\(month: .twoDigits)\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased))\(minute: .twoDigits)\(second: .twoDigits)Z",
        timeZone: .gmt,
        calendar: Calendar(identifier: .iso8601)
    )

    /// Format for credential scope date stamp (e.g., "20130524").
    private static let dateStampFormat = Date.VerbatimFormatStyle(
        format: "\(year: .defaultDigits)\(month: .twoDigits)\(day: .twoDigits)",
        timeZone: .gmt,
        calendar: Calendar(identifier: .iso8601)
    )
}

// MARK: - Data Extension

private extension Data {
    /// Returns lowercase hex-encoded string.
    var hexString: String {
        map { String(format: "%02x", $0) }.joined()
    }
}
