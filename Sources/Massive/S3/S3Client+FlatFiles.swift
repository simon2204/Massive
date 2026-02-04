import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: - Massive Flat Files

extension S3Client {
    /// The Massive Flat Files endpoint.
    public static let massiveFlatFilesEndpoint = URL(string: "https://files.massive.com")!

    /// The Massive Flat Files bucket name.
    public static let massiveFlatFilesBucket = "flatfiles"

    /// Creates an S3 client for Massive Flat Files.
    ///
    /// This factory method configures the client with the Massive Flat Files
    /// endpoint and bucket. You only need to provide your S3 credentials.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let credentials = S3Credentials(
    ///     accessKeyId: "your-access-key",
    ///     secretAccessKey: "your-secret-key"
    /// )
    /// let s3 = S3Client.massiveFlatFiles(credentials: credentials)
    ///
    /// // List available data
    /// let result = try await s3.list(prefix: "us_stocks_sip/")
    ///
    /// // Download a file
    /// let data = try await s3.download(key: "us_stocks_sip/trades_v1/2025/11/2025-11-05.csv.gz")
    /// ```
    ///
    /// - Parameters:
    ///   - credentials: Your S3 credentials from the Massive dashboard.
    ///   - session: The URLSession to use (default: `.shared`).
    /// - Returns: An S3 client configured for Massive Flat Files.
    public static func massiveFlatFiles(
        credentials: S3Credentials,
        session: URLSession = .shared
    ) -> S3Client {
        S3Client(
            endpoint: massiveFlatFilesEndpoint,
            bucket: massiveFlatFilesBucket,
            credentials: credentials,
            session: session
        )
    }

    /// Lists flat files for a specific asset class and data type.
    ///
    /// ## Available Asset Classes
    ///
    /// - `us_stocks_sip` - US Stocks (SIP)
    /// - `us_options_opra` - US Options (OPRA)
    /// - `indices` - Indices
    /// - `forex` - Forex
    /// - `crypto` - Crypto
    ///
    /// ## Available Data Types
    ///
    /// - `trades_v1` - Trades
    /// - `quotes_v1` - Quotes
    /// - `minute_aggs_v1` - Minute Aggregates
    /// - `day_aggs_v1` - Day Aggregates
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `us_stocks_sip`).
    ///   - dataType: The data type (e.g., `trades_v1`).
    ///   - year: Optional year filter (e.g., `2025`).
    ///   - month: Optional month filter (e.g., `11`). Requires `year`.
    /// - Returns: A list result containing matching files.
    public func listFlatFiles(
        assetClass: String,
        dataType: String,
        year: Int? = nil,
        month: Int? = nil
    ) async throws -> S3ListResult {
        var prefix = "\(assetClass)/\(dataType)/"

        if let year {
            prefix += "\(year)/"
            if let month {
                prefix += String(format: "%02d/", month)
            }
        }

        return try await list(prefix: prefix)
    }

    /// Downloads a flat file for a specific date.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `us_stocks_sip`).
    ///   - dataType: The data type (e.g., `trades_v1`).
    ///   - date: The date string in `YYYY-MM-DD` format.
    /// - Returns: The compressed CSV data (gzip).
    public func downloadFlatFile(
        assetClass: String,
        dataType: String,
        date: String
    ) async throws -> Data {
        let key = try flatFileKey(assetClass: assetClass, dataType: dataType, date: date)
        return try await download(key: key)
    }

    /// Downloads a flat file to a local file.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `us_stocks_sip`).
    ///   - dataType: The data type (e.g., `trades_v1`).
    ///   - date: The date string in `YYYY-MM-DD` format.
    ///   - destination: The local file URL to save to.
    public func downloadFlatFile(
        assetClass: String,
        dataType: String,
        date: String,
        to destination: URL
    ) async throws {
        let key = try flatFileKey(assetClass: assetClass, dataType: dataType, date: date)
        try await download(key: key, to: destination)
    }

    // MARK: - Private

    private func flatFileKey(assetClass: String, dataType: String, date: String) throws -> String {
        let components = date.split(separator: "-")
        guard components.count >= 2 else {
            throw S3Error.invalidResponse
        }

        let year = components[0]
        let month = components[1]
        return "\(assetClass)/\(dataType)/\(year)/\(month)/\(date).csv.gz"
    }
}
