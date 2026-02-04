import Foundation
import Testing
@testable import Massive

@Suite("S3Parsing")
struct S3ParsingTests {

    // MARK: - Mock Data

    let mockListXml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        <Name>flatfiles</Name>
        <Prefix>us_stocks_sip/trades_v1/2025/</Prefix>
        <IsTruncated>false</IsTruncated>
        <Contents>
            <Key>us_stocks_sip/trades_v1/2025/11/2025-11-05.csv.gz</Key>
            <LastModified>2025-11-06T10:30:00.000Z</LastModified>
            <ETag>"d41d8cd98f00b204e9800998ecf8427e"</ETag>
            <Size>1048576</Size>
        </Contents>
        <Contents>
            <Key>us_stocks_sip/trades_v1/2025/11/2025-11-06.csv.gz</Key>
            <LastModified>2025-11-07T10:30:00Z</LastModified>
            <ETag>"abc123"</ETag>
            <Size>2097152</Size>
        </Contents>
    </ListBucketResult>
    """.data(using: .utf8)!

    let mockListEmptyXml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        <Name>flatfiles</Name>
        <Prefix>nonexistent/</Prefix>
        <IsTruncated>false</IsTruncated>
    </ListBucketResult>
    """.data(using: .utf8)!

    let mockListPaginatedXml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <ListBucketResult>
        <IsTruncated>true</IsTruncated>
        <NextContinuationToken>token123abc</NextContinuationToken>
        <Contents>
            <Key>file1.csv.gz</Key>
            <LastModified>2025-11-06T10:30:00Z</LastModified>
            <ETag>"abc"</ETag>
            <Size>1024</Size>
        </Contents>
    </ListBucketResult>
    """.data(using: .utf8)!

    let mockS3ErrorXml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <Error>
        <Code>AccessDenied</Code>
        <Message>Access Denied</Message>
        <RequestId>ABCD1234</RequestId>
    </Error>
    """.data(using: .utf8)!

    // MARK: - ListBucketResult Parsing Tests

    @Test("Parse ListBucketResult XML")
    func parseListBucketResult() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListXml)

        #expect(result.objects.count == 2)
        #expect(result.isTruncated == false)
        #expect(result.nextContinuationToken == nil)
        #expect(result.prefix == "us_stocks_sip/trades_v1/2025/")
    }

    @Test("Parse S3 objects correctly")
    func parseS3Objects() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListXml)

        let first = result.objects[0]
        #expect(first.key == "us_stocks_sip/trades_v1/2025/11/2025-11-05.csv.gz")
        #expect(first.size == 1048576)
        #expect(first.etag == "d41d8cd98f00b204e9800998ecf8427e")
        #expect(first.lastModified.timeIntervalSince1970 > 0)

        let second = result.objects[1]
        #expect(second.key == "us_stocks_sip/trades_v1/2025/11/2025-11-06.csv.gz")
        #expect(second.size == 2097152)
    }

    @Test("Parse empty list result")
    func parseEmptyListResult() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListEmptyXml)

        #expect(result.objects.isEmpty)
        #expect(result.isTruncated == false)
    }

    @Test("Parse paginated result")
    func parsePaginatedResult() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListPaginatedXml)

        #expect(result.isTruncated == true)
        #expect(result.nextContinuationToken == "token123abc")
        #expect(result.objects.count == 1)
    }

    // MARK: - Date Parsing Tests

    @Test("Parse ISO8601 date with fractional seconds")
    func parseDateWithFractionalSeconds() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListXml)

        // First object has fractional seconds: 2025-11-06T10:30:00.000Z
        let date = result.objects[0].lastModified
        #expect(date.timeIntervalSince1970 > 0)
    }

    @Test("Parse ISO8601 date without fractional seconds")
    func parseDateWithoutFractionalSeconds() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListXml)

        // Second object has no fractional seconds: 2025-11-07T10:30:00Z
        let date = result.objects[1].lastModified
        #expect(date.timeIntervalSince1970 > 0)
    }

    @Test("Both date formats produce valid dates")
    func bothDateFormatsValid() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListXml)

        // Both dates should be parsed successfully
        let date1 = result.objects[0].lastModified
        let date2 = result.objects[1].lastModified

        // date2 (2025-11-07) should be after date1 (2025-11-06)
        #expect(date2 > date1)
    }

    // MARK: - ETag Tests

    @Test("ETag quotes are removed")
    func etagQuotesRemoved() throws {
        let parser = S3ListResultParser()
        let result = try parser.parse(mockListXml)

        #expect(!result.objects[0].etag.contains("\""))
        #expect(result.objects[0].etag == "d41d8cd98f00b204e9800998ecf8427e")
    }

    @Test("ETag without quotes is preserved")
    func etagWithoutQuotes() throws {
        let xmlWithoutQuotes = """
        <?xml version="1.0" encoding="UTF-8"?>
        <ListBucketResult>
            <IsTruncated>false</IsTruncated>
            <Contents>
                <Key>test.csv.gz</Key>
                <LastModified>2025-11-06T10:30:00Z</LastModified>
                <ETag>abc123def456</ETag>
                <Size>1024</Size>
            </Contents>
        </ListBucketResult>
        """.data(using: .utf8)!

        let parser = S3ListResultParser()
        let result = try parser.parse(xmlWithoutQuotes)

        #expect(result.objects[0].etag == "abc123def456")
    }

    // MARK: - S3 Error Parsing Tests

    @Test("Parse S3 error XML")
    func parseS3ErrorXml() {
        let parser = S3ErrorParser()
        let error = parser.parse(mockS3ErrorXml, statusCode: 403)

        if case .httpError(let statusCode, let message) = error {
            #expect(statusCode == 403)
            #expect(message == "Access Denied")
        } else {
            #expect(Bool(false), "Expected httpError")
        }
    }

    @Test("Parse S3 error with only Code")
    func parseS3ErrorCodeOnly() {
        let errorXml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Error>
            <Code>NoSuchKey</Code>
        </Error>
        """.data(using: .utf8)!

        let parser = S3ErrorParser()
        let error = parser.parse(errorXml, statusCode: 404)

        if case .httpError(let statusCode, let message) = error {
            #expect(statusCode == 404)
            #expect(message == "NoSuchKey")
        } else {
            #expect(Bool(false), "Expected httpError")
        }
    }

    @Test("Parse S3 error preserves status code")
    func parseS3ErrorStatusCode() {
        let parser = S3ErrorParser()

        let error401 = parser.parse(mockS3ErrorXml, statusCode: 401)
        if case .httpError(let statusCode, _) = error401 {
            #expect(statusCode == 401)
        }

        let error500 = parser.parse(mockS3ErrorXml, statusCode: 500)
        if case .httpError(let statusCode, _) = error500 {
            #expect(statusCode == 500)
        }
    }

    // MARK: - Edge Cases

    @Test("Parse empty XML data throws error")
    func parseEmptyXml() {
        let parser = S3ListResultParser()

        do {
            _ = try parser.parse(Data())
            #expect(Bool(false), "Should have thrown an error")
        } catch let error as S3Error {
            if case .xmlParseError = error {
                #expect(Bool(true))
            } else {
                #expect(Bool(false), "Expected xmlParseError")
            }
        } catch {
            #expect(Bool(true)) // Any error is acceptable for invalid XML
        }
    }

    @Test("Parse malformed XML throws error")
    func parseMalformedXml() {
        let malformedXml = "not valid xml at all".data(using: .utf8)!
        let parser = S3ListResultParser()

        do {
            _ = try parser.parse(malformedXml)
            #expect(Bool(false), "Should have thrown an error")
        } catch {
            #expect(Bool(true)) // Any error is acceptable for invalid XML
        }
    }

    @Test("Parse result with nil prefix")
    func parseNilPrefix() throws {
        let xmlNoPrefix = """
        <?xml version="1.0" encoding="UTF-8"?>
        <ListBucketResult>
            <IsTruncated>false</IsTruncated>
        </ListBucketResult>
        """.data(using: .utf8)!

        let parser = S3ListResultParser()
        let result = try parser.parse(xmlNoPrefix)

        #expect(result.prefix == nil)
    }

    @Test("Parse result with empty prefix")
    func parseEmptyPrefix() throws {
        let xmlEmptyPrefix = """
        <?xml version="1.0" encoding="UTF-8"?>
        <ListBucketResult>
            <Prefix></Prefix>
            <IsTruncated>false</IsTruncated>
        </ListBucketResult>
        """.data(using: .utf8)!

        let parser = S3ListResultParser()
        let result = try parser.parse(xmlEmptyPrefix)

        #expect(result.prefix == nil)
    }

    @Test("Parse large size value")
    func parseLargeSize() throws {
        let xmlLargeSize = """
        <?xml version="1.0" encoding="UTF-8"?>
        <ListBucketResult>
            <IsTruncated>false</IsTruncated>
            <Contents>
                <Key>large-file.csv.gz</Key>
                <LastModified>2025-11-06T10:30:00Z</LastModified>
                <ETag>"abc"</ETag>
                <Size>10737418240</Size>
            </Contents>
        </ListBucketResult>
        """.data(using: .utf8)!

        let parser = S3ListResultParser()
        let result = try parser.parse(xmlLargeSize)

        #expect(result.objects[0].size == 10737418240) // 10 GB
    }
}
