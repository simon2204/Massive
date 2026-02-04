import Foundation
import Testing
@testable import Massive

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("S3Signer")
struct S3SignerTests {

    // MARK: - SHA256 Tests

    @Test("SHA256 hash of empty data")
    func sha256HashEmpty() {
        let hash = S3Signer.sha256Hex(Data())
        #expect(hash == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    }

    @Test("SHA256 hash of known data")
    func sha256HashKnownData() {
        let data = "hello".data(using: .utf8)!
        let hash = S3Signer.sha256Hex(data)
        #expect(hash == "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824")
    }

    // MARK: - URI Encoding Tests

    @Test("URI encode preserves slash when encodeSlash is false")
    func uriEncodePreservesSlash() {
        let encoded = S3Signer.uriEncode("/path/to/file", encodeSlash: false)
        #expect(encoded == "/path/to/file")
    }

    @Test("URI encode encodes slash when encodeSlash is true")
    func uriEncodeEncodesSlash() {
        let encoded = S3Signer.uriEncode("/path/to/file", encodeSlash: true)
        #expect(encoded == "%2Fpath%2Fto%2Ffile")
    }

    @Test("URI encode special characters")
    func uriEncodeSpecialChars() {
        let encoded = S3Signer.uriEncode("hello world+test", encodeSlash: true)
        #expect(encoded.contains("%20"))
        #expect(encoded.contains("%2B"))
    }

    @Test("URI encode preserves safe characters")
    func uriEncodePreservesSafeChars() {
        let encoded = S3Signer.uriEncode("abc-._~123", encodeSlash: true)
        #expect(encoded == "abc-._~123")
    }

    // MARK: - Canonical Query String Tests

    @Test("Canonical query string sorted alphabetically")
    func canonicalQueryStringSorted() {
        let url = URL(string: "https://example.com?z=last&a=first&m=middle")!
        let canonical = S3Signer.canonicalQueryString(from: url)
        #expect(canonical == "a=first&m=middle&z=last")
    }

    @Test("Canonical query string empty")
    func canonicalQueryStringEmpty() {
        let url = URL(string: "https://example.com")!
        let canonical = S3Signer.canonicalQueryString(from: url)
        #expect(canonical == "")
    }

    @Test("Canonical query string encodes values")
    func canonicalQueryStringEncodes() {
        let url = URL(string: "https://example.com?key=hello%20world")!
        let canonical = S3Signer.canonicalQueryString(from: url)
        #expect(canonical.contains("hello%20world"))
    }

    // MARK: - Request Signing Tests

    @Test("Sign request adds required headers")
    func signRequestAddsHeaders() {
        let signer = S3Signer(
            credentials: S3Credentials(accessKeyId: "AKIATEST", secretAccessKey: "secret"),
            region: "us-east-1"
        )

        var request = URLRequest(url: URL(string: "https://files.massive.com/flatfiles/test.csv")!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)

        #expect(signedRequest.value(forHTTPHeaderField: "Authorization") != nil)
        #expect(signedRequest.value(forHTTPHeaderField: "x-amz-date") != nil)
        #expect(signedRequest.value(forHTTPHeaderField: "x-amz-content-sha256") != nil)
        #expect(signedRequest.value(forHTTPHeaderField: "Host") == "files.massive.com")
    }

    @Test("Sign request authorization header format")
    func signRequestAuthFormat() {
        let signer = S3Signer(
            credentials: S3Credentials(accessKeyId: "AKIATEST", secretAccessKey: "secret"),
            region: "us-east-1"
        )

        var request = URLRequest(url: URL(string: "https://files.massive.com/flatfiles/test.csv")!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let auth = signedRequest.value(forHTTPHeaderField: "Authorization") ?? ""

        #expect(auth.hasPrefix("AWS4-HMAC-SHA256"))
        #expect(auth.contains("Credential=AKIATEST/"))
        #expect(auth.contains("/us-east-1/s3/aws4_request"))
        #expect(auth.contains("SignedHeaders="))
        #expect(auth.contains("Signature="))
    }

    @Test("Sign request includes credential scope")
    func signRequestCredentialScope() {
        let signer = S3Signer(
            credentials: S3Credentials(accessKeyId: "AKIATEST", secretAccessKey: "secret"),
            region: "eu-west-1"
        )

        var request = URLRequest(url: URL(string: "https://example.com/bucket/key")!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let auth = signedRequest.value(forHTTPHeaderField: "Authorization") ?? ""

        #expect(auth.contains("/eu-west-1/s3/aws4_request"))
    }

    @Test("Sign request x-amz-content-sha256 is correct for empty body")
    func signRequestEmptyBodyHash() {
        let signer = S3Signer(
            credentials: S3Credentials(accessKeyId: "AKIATEST", secretAccessKey: "secret"),
            region: "us-east-1"
        )

        var request = URLRequest(url: URL(string: "https://example.com/bucket/key")!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let contentHash = signedRequest.value(forHTTPHeaderField: "x-amz-content-sha256")

        // SHA256 of empty string
        #expect(contentHash == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    }

    @Test("Sign request x-amz-date format")
    func signRequestDateFormat() {
        let signer = S3Signer(
            credentials: S3Credentials(accessKeyId: "AKIATEST", secretAccessKey: "secret"),
            region: "us-east-1"
        )

        var request = URLRequest(url: URL(string: "https://example.com/bucket/key")!)
        request.httpMethod = "GET"

        let signedRequest = signer.sign(request)
        let dateHeader = signedRequest.value(forHTTPHeaderField: "x-amz-date") ?? ""

        // Format should be: YYYYMMDDTHHMMSSZ
        #expect(dateHeader.count == 16)
        #expect(dateHeader.contains("T"))
        #expect(dateHeader.hasSuffix("Z"))
    }
}
