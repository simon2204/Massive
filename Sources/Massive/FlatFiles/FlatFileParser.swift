import Foundation
import SWCompression
import Fetch

/// Parses CSV flat files from Massive.
///
/// Handles gzip decompression and CSV parsing for all flat file types.
public enum FlatFileParser {

    // MARK: - Minute Aggregates

    /// Parses minute aggregate data from gzipped CSV.
    ///
    /// - Parameter data: The gzip-compressed CSV data.
    /// - Returns: An array of minute aggregates.
    public static func parseMinuteAggregates(from data: Data) throws -> [MinuteAggregate] {
        let csv = try decompress(data)
        return try parseMinuteAggregatesCSV(csv)
    }

    /// Parses minute aggregate data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of minute aggregates.
    public static func parseMinuteAggregatesCSV(_ csv: String) throws -> [MinuteAggregate] {
        let lines = csv.split(separator: "\n", omittingEmptySubsequences: true)
        guard lines.count > 1 else { return [] }

        // Parse header to get column indices
        let header = lines[0].split(separator: ",").map { String($0) }
        let indices = MinuteAggregateIndices(header: header)

        var results: [MinuteAggregate] = []
        results.reserveCapacity(lines.count - 1)

        for line in lines.dropFirst() {
            let fields = line.split(separator: ",", omittingEmptySubsequences: false).map { String($0) }
            guard fields.count > indices.maxIndex else { continue }

            let agg = MinuteAggregate(
                ticker: fields[indices.ticker],
                volume: Int(fields[indices.volume]) ?? 0,
                open: Double(fields[indices.open]) ?? 0,
                close: Double(fields[indices.close]) ?? 0,
                high: Double(fields[indices.high]) ?? 0,
                low: Double(fields[indices.low]) ?? 0,
                windowStart: Timestamp(nanosecondsSinceEpoch: Int64(fields[indices.windowStart]) ?? 0),
                transactions: Int(fields[indices.transactions]) ?? 0
            )
            results.append(agg)
        }

        return results
    }

    // MARK: - Day Aggregates

    /// Parses day aggregate data from gzipped CSV.
    ///
    /// - Parameter data: The gzip-compressed CSV data.
    /// - Returns: An array of day aggregates.
    public static func parseDayAggregates(from data: Data) throws -> [DayAggregate] {
        let csv = try decompress(data)
        return try parseDayAggregatesCSV(csv)
    }

    /// Parses day aggregate data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of day aggregates.
    public static func parseDayAggregatesCSV(_ csv: String) throws -> [DayAggregate] {
        let lines = csv.split(separator: "\n", omittingEmptySubsequences: true)
        guard lines.count > 1 else { return [] }

        let header = lines[0].split(separator: ",").map { String($0) }
        let indices = DayAggregateIndices(header: header)

        var results: [DayAggregate] = []
        results.reserveCapacity(lines.count - 1)

        for line in lines.dropFirst() {
            let fields = line.split(separator: ",", omittingEmptySubsequences: false).map { String($0) }
            guard fields.count > indices.maxIndex else { continue }

            let agg = DayAggregate(
                ticker: fields[indices.ticker],
                volume: Int(fields[indices.volume]) ?? 0,
                open: Double(fields[indices.open]) ?? 0,
                close: Double(fields[indices.close]) ?? 0,
                high: Double(fields[indices.high]) ?? 0,
                low: Double(fields[indices.low]) ?? 0,
                windowStart: Timestamp(nanosecondsSinceEpoch: Int64(fields[indices.windowStart]) ?? 0),
                transactions: Int(fields[indices.transactions]) ?? 0
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
        let csv = try decompress(data)
        return try parseTradesCSV(csv)
    }

    /// Parses trade data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of trades.
    public static func parseTradesCSV(_ csv: String) throws -> [Trade] {
        let lines = csv.split(separator: "\n", omittingEmptySubsequences: true)
        guard lines.count > 1 else { return [] }

        let header = lines[0].split(separator: ",").map { String($0) }
        let indices = TradeIndices(header: header)

        var results: [Trade] = []
        results.reserveCapacity(lines.count - 1)

        for line in lines.dropFirst() {
            let fields = parseCSVLine(line)
            guard fields.count > indices.maxIndex else { continue }

            let trade = Trade(
                ticker: fields[indices.ticker],
                conditions: parseIntArray(fields[indices.conditions]),
                correction: Int(fields[indices.correction]) ?? 0,
                exchange: Int(fields[indices.exchange]) ?? 0,
                id: fields[indices.id],
                participantTimestamp: Timestamp(nanosecondsSinceEpoch: Int64(fields[indices.participantTimestamp]) ?? 0),
                price: Double(fields[indices.price]) ?? 0,
                sequenceNumber: Int(fields[indices.sequenceNumber]) ?? 0,
                sipTimestamp: Timestamp(nanosecondsSinceEpoch: Int64(fields[indices.sipTimestamp]) ?? 0),
                size: Int(fields[indices.size]) ?? 0,
                tape: Int(fields[indices.tape]) ?? 0,
                trfId: Int(fields[indices.trfId]),
                trfTimestamp: Int64(fields[indices.trfTimestamp]).map { Timestamp(nanosecondsSinceEpoch: $0) }
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
        let csv = try decompress(data)
        return try parseQuotesCSV(csv)
    }

    /// Parses quote data from uncompressed CSV string.
    ///
    /// - Parameter csv: The CSV content.
    /// - Returns: An array of quotes.
    public static func parseQuotesCSV(_ csv: String) throws -> [Quote] {
        let lines = csv.split(separator: "\n", omittingEmptySubsequences: true)
        guard lines.count > 1 else { return [] }

        let header = lines[0].split(separator: ",").map { String($0) }
        let indices = QuoteIndices(header: header)

        var results: [Quote] = []
        results.reserveCapacity(lines.count - 1)

        for line in lines.dropFirst() {
            let fields = parseCSVLine(line)
            guard fields.count > indices.maxIndex else { continue }

            let quote = Quote(
                ticker: fields[indices.ticker],
                askExchange: Int(fields[indices.askExchange]) ?? 0,
                askPrice: Double(fields[indices.askPrice]) ?? 0,
                askSize: Int(fields[indices.askSize]) ?? 0,
                bidExchange: Int(fields[indices.bidExchange]) ?? 0,
                bidPrice: Double(fields[indices.bidPrice]) ?? 0,
                bidSize: Int(fields[indices.bidSize]) ?? 0,
                conditions: parseIntArray(fields[indices.conditions]),
                indicators: parseIntArray(fields[indices.indicators]),
                participantTimestamp: Timestamp(nanosecondsSinceEpoch: Int64(fields[indices.participantTimestamp]) ?? 0),
                sequenceNumber: Int(fields[indices.sequenceNumber]) ?? 0,
                sipTimestamp: Timestamp(nanosecondsSinceEpoch: Int64(fields[indices.sipTimestamp]) ?? 0),
                tape: Int(fields[indices.tape]) ?? 0,
                trfTimestamp: Int64(fields[indices.trfTimestamp]).map { Timestamp(nanosecondsSinceEpoch: $0) }
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
        // Check for gzip magic number (0x1f, 0x8b)
        guard data.count >= 2, data[0] == 0x1f, data[1] == 0x8b else {
            // Not gzip, treat as plain text
            guard let string = String(data: data, encoding: .utf8) else {
                throw FlatFileError.invalidData
            }
            return string
        }

        do {
            let decompressed = try GzipArchive.unarchive(archive: data)
            guard let string = String(data: decompressed, encoding: .utf8) else {
                throw FlatFileError.invalidData
            }
            return string
        } catch {
            throw FlatFileError.invalidData
        }
    }

    // MARK: - Helpers

    private static func parseIntArray(_ string: String) -> [Int] {
        let cleaned = string.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        guard !cleaned.isEmpty else { return [] }

        return cleaned.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }

    /// Parses a CSV line into fields, handling quoted fields with commas.
    internal static func parseCSVLine(_ line: some StringProtocol) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false

        for char in line {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                fields.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }
        fields.append(current)

        return fields
    }
}

// MARK: - Errors

/// Errors that can occur when parsing flat files.
public enum FlatFileError: Error {
    /// The data is invalid or corrupted.
    case invalidData
    /// A required column is missing from the CSV.
    case missingColumn(String)
}

// MARK: - Column Indices

private struct MinuteAggregateIndices {
    let ticker: Int
    let volume: Int
    let open: Int
    let close: Int
    let high: Int
    let low: Int
    let windowStart: Int
    let transactions: Int
    let maxIndex: Int

    init(header: [String]) {
        ticker = header.firstIndex(of: "ticker") ?? 0
        volume = header.firstIndex(of: "volume") ?? 1
        open = header.firstIndex(of: "open") ?? 2
        close = header.firstIndex(of: "close") ?? 3
        high = header.firstIndex(of: "high") ?? 4
        low = header.firstIndex(of: "low") ?? 5
        windowStart = header.firstIndex(of: "window_start") ?? 6
        transactions = header.firstIndex(of: "transactions") ?? 7
        maxIndex = max(ticker, volume, open, close, high, low, windowStart, transactions)
    }
}

private struct DayAggregateIndices {
    let ticker: Int
    let volume: Int
    let open: Int
    let close: Int
    let high: Int
    let low: Int
    let windowStart: Int
    let transactions: Int
    let maxIndex: Int

    init(header: [String]) {
        ticker = header.firstIndex(of: "ticker") ?? 0
        volume = header.firstIndex(of: "volume") ?? 1
        open = header.firstIndex(of: "open") ?? 2
        close = header.firstIndex(of: "close") ?? 3
        high = header.firstIndex(of: "high") ?? 4
        low = header.firstIndex(of: "low") ?? 5
        windowStart = header.firstIndex(of: "window_start") ?? 6
        transactions = header.firstIndex(of: "transactions") ?? 7
        maxIndex = max(ticker, volume, open, close, high, low, windowStart, transactions)
    }
}

private struct TradeIndices {
    let ticker: Int
    let conditions: Int
    let correction: Int
    let exchange: Int
    let id: Int
    let participantTimestamp: Int
    let price: Int
    let sequenceNumber: Int
    let sipTimestamp: Int
    let size: Int
    let tape: Int
    let trfId: Int
    let trfTimestamp: Int
    let maxIndex: Int

    init(header: [String]) {
        ticker = header.firstIndex(of: "ticker") ?? 0
        conditions = header.firstIndex(of: "conditions") ?? 1
        correction = header.firstIndex(of: "correction") ?? 2
        exchange = header.firstIndex(of: "exchange") ?? 3
        id = header.firstIndex(of: "id") ?? 4
        participantTimestamp = header.firstIndex(of: "participant_timestamp") ?? 5
        price = header.firstIndex(of: "price") ?? 6
        sequenceNumber = header.firstIndex(of: "sequence_number") ?? 7
        sipTimestamp = header.firstIndex(of: "sip_timestamp") ?? 8
        size = header.firstIndex(of: "size") ?? 9
        tape = header.firstIndex(of: "tape") ?? 10
        trfId = header.firstIndex(of: "trf_id") ?? 11
        trfTimestamp = header.firstIndex(of: "trf_timestamp") ?? 12
        maxIndex = max(ticker, conditions, correction, exchange, id, participantTimestamp,
                       price, sequenceNumber, sipTimestamp, size, tape, trfId, trfTimestamp)
    }
}

private struct QuoteIndices {
    let ticker: Int
    let askExchange: Int
    let askPrice: Int
    let askSize: Int
    let bidExchange: Int
    let bidPrice: Int
    let bidSize: Int
    let conditions: Int
    let indicators: Int
    let participantTimestamp: Int
    let sequenceNumber: Int
    let sipTimestamp: Int
    let tape: Int
    let trfTimestamp: Int
    let maxIndex: Int

    init(header: [String]) {
        ticker = header.firstIndex(of: "ticker") ?? 0
        askExchange = header.firstIndex(of: "ask_exchange") ?? 1
        askPrice = header.firstIndex(of: "ask_price") ?? 2
        askSize = header.firstIndex(of: "ask_size") ?? 3
        bidExchange = header.firstIndex(of: "bid_exchange") ?? 4
        bidPrice = header.firstIndex(of: "bid_price") ?? 5
        bidSize = header.firstIndex(of: "bid_size") ?? 6
        conditions = header.firstIndex(of: "conditions") ?? 7
        indicators = header.firstIndex(of: "indicators") ?? 8
        participantTimestamp = header.firstIndex(of: "participant_timestamp") ?? 9
        sequenceNumber = header.firstIndex(of: "sequence_number") ?? 10
        sipTimestamp = header.firstIndex(of: "sip_timestamp") ?? 11
        tape = header.firstIndex(of: "tape") ?? 12
        trfTimestamp = header.firstIndex(of: "trf_timestamp") ?? 13
        maxIndex = max(ticker, askExchange, askPrice, askSize, bidExchange, bidPrice, bidSize,
                       conditions, indicators, participantTimestamp, sequenceNumber, sipTimestamp, tape, trfTimestamp)
    }
}
