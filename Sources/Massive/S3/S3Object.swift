import Foundation

/// Result of an S3 list objects operation.
public struct S3ListResult: Sendable {
    /// The objects in the current page.
    public let objects: [S3Object]

    /// Whether there are more objects to fetch.
    public let isTruncated: Bool

    /// Token to use for fetching the next page (if `isTruncated` is true).
    public let nextContinuationToken: String?

    /// The prefix used for filtering (if any).
    public let prefix: String?
}

/// An object (file) in an S3 bucket.
public struct S3Object: Sendable {
    /// The object key (path/filename).
    public let key: String

    /// The size in bytes.
    public let size: Int

    /// The last modified date.
    public let lastModified: Date

    /// The ETag (usually MD5 hash of the content).
    public let etag: String
}

/// Errors that can occur during S3 operations.
public enum S3Error: Error, Sendable {
    /// The server returned an invalid or unexpected response.
    case invalidResponse
    /// The server returned an HTTP error.
    case httpError(statusCode: Int, message: String?)
    /// Failed to parse the XML response.
    case xmlParseError(String)
    /// The requested object was not found.
    case notFound(key: String)
}

// MARK: - XML Parsing

/// Parser for S3 ListBucketResult XML responses.
final class S3ListResultParser: NSObject, XMLParserDelegate, @unchecked Sendable {
    private var objects: [S3Object] = []
    private var isTruncated = false
    private var nextContinuationToken: String?
    private var prefix: String?

    // Current object being parsed
    private var currentKey: String?
    private var currentSize: Int?
    private var currentLastModified: Date?
    private var currentETag: String?

    // Parser state
    private var currentElement = ""
    private var currentText = ""
    private var inContents = false

    private nonisolated(unsafe) static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private nonisolated(unsafe) static let iso8601FormatterNoFraction: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    /// Parses S3 ListBucketResult XML data.
    func parse(_ data: Data) throws -> S3ListResult {
        let parser = XMLParser(data: data)
        parser.delegate = self

        guard parser.parse() else {
            throw S3Error.xmlParseError(parser.parserError?.localizedDescription ?? "Unknown error")
        }

        return S3ListResult(
            objects: objects,
            isTruncated: isTruncated,
            nextContinuationToken: nextContinuationToken,
            prefix: prefix
        )
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        currentText = ""

        if elementName == "Contents" {
            inContents = true
            currentKey = nil
            currentSize = nil
            currentLastModified = nil
            currentETag = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let text = currentText.trimmingCharacters(in: .whitespacesAndNewlines)

        switch elementName {
        case "Contents":
            if let key = currentKey,
               let size = currentSize,
               let lastModified = currentLastModified,
               let etag = currentETag {
                objects.append(S3Object(
                    key: key,
                    size: size,
                    lastModified: lastModified,
                    etag: etag.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                ))
            }
            inContents = false

        case "Key" where inContents:
            currentKey = text

        case "Size" where inContents:
            currentSize = Int(text)

        case "LastModified" where inContents:
            currentLastModified = Self.iso8601Formatter.date(from: text)
                ?? Self.iso8601FormatterNoFraction.date(from: text)

        case "ETag" where inContents:
            currentETag = text

        case "IsTruncated":
            isTruncated = text.lowercased() == "true"

        case "NextContinuationToken":
            nextContinuationToken = text

        case "Prefix":
            if !inContents {
                prefix = text.isEmpty ? nil : text
            }

        default:
            break
        }

        currentText = ""
    }
}

/// Parser for S3 error responses.
final class S3ErrorParser: NSObject, XMLParserDelegate, @unchecked Sendable {
    private var code: String?
    private var message: String?
    private var currentElement = ""
    private var currentText = ""

    /// Parses S3 error XML and returns an S3Error.
    func parse(_ data: Data, statusCode: Int) -> S3Error {
        let parser = XMLParser(data: data)
        parser.delegate = self
        _ = parser.parse()

        return .httpError(statusCode: statusCode, message: message ?? code)
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        currentText = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let text = currentText.trimmingCharacters(in: .whitespacesAndNewlines)

        switch elementName {
        case "Code":
            code = text
        case "Message":
            message = text
        default:
            break
        }
    }
}
