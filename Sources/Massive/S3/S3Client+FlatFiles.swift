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
    /// // Download and parse minute aggregates
    /// let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")
    ///
    /// // Download and parse trades
    /// let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")
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

    // MARK: - Typed API

    /// Downloads and parses minute aggregates for a specific date.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `.usStocks`).
    ///   - date: The date in `YYYY-MM-DD` format.
    /// - Returns: An array of minute aggregates.
    public func minuteAggregates(
        for assetClass: AssetClass,
        date: String
    ) async throws -> [MinuteAggregate] {
        let data = try await downloadFlatFile(
            assetClass: assetClass.rawValue,
            dataType: DataType.minuteAggregates.rawValue,
            date: date
        )
        return try FlatFileParser.parseMinuteAggregates(from: data)
    }

    /// Downloads and parses day aggregates for a specific date.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `.usStocks`).
    ///   - date: The date in `YYYY-MM-DD` format.
    /// - Returns: An array of day aggregates.
    public func dayAggregates(
        for assetClass: AssetClass,
        date: String
    ) async throws -> [DayAggregate] {
        let data = try await downloadFlatFile(
            assetClass: assetClass.rawValue,
            dataType: DataType.dayAggregates.rawValue,
            date: date
        )
        return try FlatFileParser.parseDayAggregates(from: data)
    }

    /// Downloads and parses trades for a specific date.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `.usStocks`).
    ///   - date: The date in `YYYY-MM-DD` format.
    /// - Returns: An array of trades.
    public func trades(
        for assetClass: AssetClass,
        date: String
    ) async throws -> [Trade] {
        let data = try await downloadFlatFile(
            assetClass: assetClass.rawValue,
            dataType: DataType.trades.rawValue,
            date: date
        )
        return try FlatFileParser.parseTrades(from: data)
    }

    /// Downloads and parses quotes for a specific date.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class (e.g., `.usStocks`).
    ///   - date: The date in `YYYY-MM-DD` format.
    /// - Returns: An array of quotes.
    public func quotes(
        for assetClass: AssetClass,
        date: String
    ) async throws -> [Quote] {
        let data = try await downloadFlatFile(
            assetClass: assetClass.rawValue,
            dataType: DataType.quotes.rawValue,
            date: date
        )
        return try FlatFileParser.parseQuotes(from: data)
    }

    // MARK: - List Files

    /// Lists flat files for a specific asset class and data type.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class.
    ///   - dataType: The data type.
    ///   - year: Optional year filter.
    ///   - month: Optional month filter. Requires `year`.
    /// - Returns: A list result containing matching files.
    public func listFlatFiles(
        assetClass: AssetClass,
        dataType: DataType,
        year: Int? = nil,
        month: Int? = nil
    ) async throws -> S3ListResult {
        try await listFlatFiles(
            assetClass: assetClass.rawValue,
            dataType: dataType.rawValue,
            year: year,
            month: month
        )
    }

    /// Lists flat files for a specific asset class and data type (string-based).
    ///
    /// - Parameters:
    ///   - assetClass: The asset class string (e.g., `us_stocks_sip`).
    ///   - dataType: The data type string (e.g., `trades_v1`).
    ///   - year: Optional year filter.
    ///   - month: Optional month filter. Requires `year`.
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

    // MARK: - Download Raw

    /// Downloads a flat file for a specific date.
    ///
    /// - Parameters:
    ///   - assetClass: The asset class.
    ///   - dataType: The data type.
    ///   - date: The date in `YYYY-MM-DD` format.
    /// - Returns: The compressed CSV data (gzip).
    public func downloadFlatFile(
        assetClass: AssetClass,
        dataType: DataType,
        date: String
    ) async throws -> Data {
        try await downloadFlatFile(
            assetClass: assetClass.rawValue,
            dataType: dataType.rawValue,
            date: date
        )
    }

    /// Downloads a flat file for a specific date (string-based).
    ///
    /// - Parameters:
    ///   - assetClass: The asset class string.
    ///   - dataType: The data type string.
    ///   - date: The date in `YYYY-MM-DD` format.
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
    ///   - assetClass: The asset class.
    ///   - dataType: The data type.
    ///   - date: The date in `YYYY-MM-DD` format.
    ///   - destination: The local file URL to save to.
    public func downloadFlatFile(
        assetClass: AssetClass,
        dataType: DataType,
        date: String,
        to destination: URL
    ) async throws {
        try await downloadFlatFile(
            assetClass: assetClass.rawValue,
            dataType: dataType.rawValue,
            date: date,
            to: destination
        )
    }

    /// Downloads a flat file to a local file (string-based).
    ///
    /// - Parameters:
    ///   - assetClass: The asset class string.
    ///   - dataType: The data type string.
    ///   - date: The date in `YYYY-MM-DD` format.
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
