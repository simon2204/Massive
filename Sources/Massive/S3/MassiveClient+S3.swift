import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension MassiveClient {
    /// The default Massive Flat Files endpoint.
    public static let flatFilesEndpoint = URL(string: "https://files.massive.com")!

    /// The default Massive Flat Files bucket name.
    public static let flatFilesBucket = "flatfiles"

    /// Creates an S3 client configured for Massive Flat Files.
    ///
    /// This is a convenience method that creates an `S3Client` with the correct
    /// endpoint and bucket for accessing Massive Flat Files.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let massiveClient = MassiveClient(apiKey: "...")
    /// let s3 = massiveClient.flatFiles(credentials: S3Credentials(
    ///     accessKeyId: "your-access-key",
    ///     secretAccessKey: "your-secret-key"
    /// ))
    ///
    /// // List available data
    /// let result = try await s3.list(prefix: "us_stocks_sip/")
    ///
    /// // Download a file
    /// let data = try await s3.download(key: "us_stocks_sip/trades_v1/2025/11/2025-11-05.csv.gz")
    /// ```
    ///
    /// - Parameter credentials: Your S3 credentials from the Massive dashboard.
    /// - Returns: An S3 client configured for Massive Flat Files.
    public func flatFiles(credentials: S3Credentials) -> S3Client {
        S3Client(
            endpoint: Self.flatFilesEndpoint,
            bucket: Self.flatFilesBucket,
            credentials: credentials,
            session: session
        )
    }
}

// MARK: - Massive Flat Files Convenience Methods

extension S3Client {
    /// Creates an S3 client for Massive Flat Files.
    ///
    /// This is a convenience initializer that configures the client with
    /// the Massive Flat Files endpoint and bucket.
    ///
    /// - Parameters:
    ///   - credentials: Your S3 credentials from the Massive dashboard.
    ///   - session: The URLSession to use (default: `.shared`).
    public static func massiveFlatFiles(
        credentials: S3Credentials,
        session: URLSession = .shared
    ) -> S3Client {
        S3Client(
            endpoint: MassiveClient.flatFilesEndpoint,
            bucket: MassiveClient.flatFilesBucket,
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
        // Parse date to get year/month
        let components = date.split(separator: "-")
        guard components.count >= 2 else {
            throw S3Error.invalidResponse
        }

        let year = components[0]
        let month = components[1]
        let key = "\(assetClass)/\(dataType)/\(year)/\(month)/\(date).csv.gz"

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
        let components = date.split(separator: "-")
        guard components.count >= 2 else {
            throw S3Error.invalidResponse
        }

        let year = components[0]
        let month = components[1]
        let key = "\(assetClass)/\(dataType)/\(year)/\(month)/\(date).csv.gz"

        try await download(key: key, to: destination)
    }
}
