import Foundation
import SWCompression
import Fetch

/// Parses CSV flat files from Massive.
///
/// Uses zero-copy UTF-8 byte parsing for optimal performance with large files.
public enum FlatFileParser {

    // MARK: - Generic Helpers

    /// Parses CSV from gzipped data using a row parser closure.
    private static func parseGzipped<T>(
        _ data: Data,
        using parser: ([UInt8]) throws -> [T]
    ) throws -> [T] {
        let bytes = try ByteParsing.decompressToBytes(data)
        return try parser(bytes)
    }

    /// Parses CSV from a string using a row parser closure.
    private static func parseCSV<T>(
        _ csv: String,
        using parser: ([UInt8]) throws -> [T]
    ) throws -> [T] {
        var csv = csv
        return try csv.withUTF8 { buffer in
            guard let baseAddress = buffer.baseAddress else { return [] }
            let bytes = Array(UnsafeBufferPointer(start: baseAddress, count: buffer.count))
            return try parser(bytes)
        }
    }

    // MARK: - Minute Aggregates

    /// Parses minute aggregate data from gzipped CSV.
    ///
    /// - Parameter data: The gzip-compressed CSV data.
    /// - Returns: An array of minute aggregates.
    public static func parseMinuteAggregates(from data: Data) throws -> [MinuteAggregate] {
        try parseGzipped(data, using: parseAggregatesFromBytes)
    }

    /// Parses minute aggregate data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of minute aggregates.
    public static func parseMinuteAggregatesCSV(_ csv: String) throws -> [MinuteAggregate] {
        try parseCSV(csv, using: parseAggregatesFromBytes)
    }

    // MARK: - Day Aggregates

    /// Parses day aggregate data from gzipped CSV.
    ///
    /// - Parameter data: The gzip-compressed CSV data.
    /// - Returns: An array of day aggregates.
    public static func parseDayAggregates(from data: Data) throws -> [DayAggregate] {
        try parseGzipped(data, using: parseAggregatesFromBytes)
    }

    /// Parses day aggregate data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of day aggregates.
    public static func parseDayAggregatesCSV(_ csv: String) throws -> [DayAggregate] {
        try parseCSV(csv, using: parseAggregatesFromBytes)
    }

    // MARK: - Aggregate Parsing (Shared)

    private static func parseAggregatesFromBytes<T: AggregateData>(_ bytes: [UInt8]) throws -> [T] {
        let lines = ByteParsing.splitLines(bytes)
        guard lines.count > 1 else { return [] }

        let header = ByteParsing.splitFields(lines[0])
        let indices = try AggregateIndices(header: header)

        var results: [T] = []
        results.reserveCapacity(lines.count - 1)

        for i in 1..<lines.count {
            let fields = ByteParsing.splitFields(lines[i])
            guard fields.count > indices.maxIndex else { continue }

            let agg = T(
                ticker: ByteParsing.stringFromBytes(fields[indices.ticker]),
                volume: ByteParsing.intFromBytes(fields[indices.volume]),
                open: ByteParsing.doubleFromBytes(fields[indices.open]),
                close: ByteParsing.doubleFromBytes(fields[indices.close]),
                high: ByteParsing.doubleFromBytes(fields[indices.high]),
                low: ByteParsing.doubleFromBytes(fields[indices.low]),
                windowStart: Timestamp(nanosecondsSinceEpoch: ByteParsing.int64FromBytes(fields[indices.windowStart])),
                transactions: ByteParsing.intFromBytes(fields[indices.transactions])
            )
            results.append(agg)
        }

        return results
    }

    // MARK: - Trades

    /// Parses trade data from gzipped CSV.
    ///
    /// - Parameter data: The gzip-compressed CSV data.
    /// - Returns: An array of trades.
    public static func parseTrades(from data: Data) throws -> [Trade] {
        try parseGzipped(data, using: parseTradesFromBytes)
    }

    /// Parses trade data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of trades.
    public static func parseTradesCSV(_ csv: String) throws -> [Trade] {
        try parseCSV(csv, using: parseTradesFromBytes)
    }

    private static func parseTradesFromBytes(_ bytes: [UInt8]) throws -> [Trade] {
        let lines = ByteParsing.splitLines(bytes)
        guard lines.count > 1 else { return [] }

        let header = ByteParsing.splitFields(lines[0])
        let indices = try TradeIndices(header: header)

        var results: [Trade] = []
        results.reserveCapacity(lines.count - 1)

        for i in 1..<lines.count {
            let fields = ByteParsing.splitFieldsQuoted(lines[i])
            guard fields.count > indices.maxIndex else { continue }

            let trade = Trade(
                ticker: ByteParsing.stringFromBytes(fields[indices.ticker]),
                conditions: ByteParsing.parseIntArrayFromBytes(fields[indices.conditions]),
                correction: ByteParsing.intFromBytes(fields[indices.correction]),
                exchange: ByteParsing.intFromBytes(fields[indices.exchange]),
                id: ByteParsing.stringFromBytes(fields[indices.id]),
                participantTimestamp: Timestamp(nanosecondsSinceEpoch: ByteParsing.int64FromBytes(fields[indices.participantTimestamp])),
                price: ByteParsing.doubleFromBytes(fields[indices.price]),
                sequenceNumber: ByteParsing.intFromBytes(fields[indices.sequenceNumber]),
                sipTimestamp: Timestamp(nanosecondsSinceEpoch: ByteParsing.int64FromBytes(fields[indices.sipTimestamp])),
                size: ByteParsing.intFromBytes(fields[indices.size]),
                tape: Tape(rawValue: ByteParsing.intFromBytes(fields[indices.tape])) ?? .nyse,
                trfId: ByteParsing.optionalIntFromBytes(fields[indices.trfId]),
                trfTimestamp: ByteParsing.optionalInt64FromBytes(fields[indices.trfTimestamp]).map { Timestamp(nanosecondsSinceEpoch: $0) }
            )
            results.append(trade)
        }

        return results
    }

    // MARK: - Quotes

    /// Parses quote data from gzipped CSV.
    ///
    /// - Parameter data: The gzip-compressed CSV data.
    /// - Returns: An array of quotes.
    public static func parseQuotes(from data: Data) throws -> [Quote] {
        try parseGzipped(data, using: parseQuotesFromBytes)
    }

    /// Parses quote data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of quotes.
    public static func parseQuotesCSV(_ csv: String) throws -> [Quote] {
        try parseCSV(csv, using: parseQuotesFromBytes)
    }

    private static func parseQuotesFromBytes(_ bytes: [UInt8]) throws -> [Quote] {
        let lines = ByteParsing.splitLines(bytes)
        guard lines.count > 1 else { return [] }

        let header = ByteParsing.splitFields(lines[0])
        let indices = try QuoteIndices(header: header)

        var results: [Quote] = []
        results.reserveCapacity(lines.count - 1)

        for i in 1..<lines.count {
            let fields = ByteParsing.splitFieldsQuoted(lines[i])
            guard fields.count > indices.maxIndex else { continue }

            let quote = Quote(
                ticker: ByteParsing.stringFromBytes(fields[indices.ticker]),
                askExchange: ByteParsing.intFromBytes(fields[indices.askExchange]),
                askPrice: ByteParsing.doubleFromBytes(fields[indices.askPrice]),
                askSize: ByteParsing.intFromBytes(fields[indices.askSize]),
                bidExchange: ByteParsing.intFromBytes(fields[indices.bidExchange]),
                bidPrice: ByteParsing.doubleFromBytes(fields[indices.bidPrice]),
                bidSize: ByteParsing.intFromBytes(fields[indices.bidSize]),
                conditions: ByteParsing.parseIntArrayFromBytes(fields[indices.conditions]),
                indicators: ByteParsing.parseIntArrayFromBytes(fields[indices.indicators]),
                participantTimestamp: Timestamp(nanosecondsSinceEpoch: ByteParsing.int64FromBytes(fields[indices.participantTimestamp])),
                sequenceNumber: ByteParsing.intFromBytes(fields[indices.sequenceNumber]),
                sipTimestamp: Timestamp(nanosecondsSinceEpoch: ByteParsing.int64FromBytes(fields[indices.sipTimestamp])),
                tape: Tape(rawValue: ByteParsing.intFromBytes(fields[indices.tape])) ?? .nyse,
                trfTimestamp: ByteParsing.optionalInt64FromBytes(fields[indices.trfTimestamp]).map { Timestamp(nanosecondsSinceEpoch: $0) }
            )
            results.append(quote)
        }

        return results
    }

    // MARK: - Decompression

    /// Decompresses gzip data to a UTF-8 string.
    ///
    /// - Parameter data: The gzip-compressed data.
    /// - Returns: The decompressed string.
    public static func decompress(_ data: Data) throws -> String {
        let bytes = try ByteParsing.decompressToBytes(data)
        guard let string = String(bytes: bytes, encoding: .utf8) else {
            throw FlatFileError.invalidData
        }
        return string
    }
}

