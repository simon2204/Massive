import Foundation

// MARK: - Column Lookup Helper

/// Finds a column index by name in a CSV header.
///
/// - Parameters:
///   - name: The column name to find.
///   - header: The header row as byte slices.
/// - Returns: The index of the column.
/// - Throws: `FlatFileError.missingColumn` if the column is not found.
@inlinable
func findColumn(_ name: String, in header: [ArraySlice<UInt8>]) throws -> Int {
    let nameBytes = Array(name.utf8)
    guard let index = header.firstIndex(where: { $0.elementsEqual(nameBytes) }) else {
        throw FlatFileError.missingColumn(name)
    }
    return index
}

// MARK: - Aggregate Indices

/// Column indices for aggregate CSV parsing (both minute and day aggregates).
struct AggregateIndices {
    let ticker: Int
    let volume: Int
    let open: Int
    let close: Int
    let high: Int
    let low: Int
    let windowStart: Int
    let transactions: Int
    let maxIndex: Int

    init(header: [ArraySlice<UInt8>]) throws {
        ticker = try findColumn("ticker", in: header)
        volume = try findColumn("volume", in: header)
        open = try findColumn("open", in: header)
        close = try findColumn("close", in: header)
        high = try findColumn("high", in: header)
        low = try findColumn("low", in: header)
        windowStart = try findColumn("window_start", in: header)
        transactions = try findColumn("transactions", in: header)
        maxIndex = max(ticker, volume, open, close, high, low, windowStart, transactions)
    }
}

// MARK: - Trade Indices

/// Column indices for trade CSV parsing.
struct TradeIndices {
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

    init(header: [ArraySlice<UInt8>]) throws {
        ticker = try findColumn("ticker", in: header)
        conditions = try findColumn("conditions", in: header)
        correction = try findColumn("correction", in: header)
        exchange = try findColumn("exchange", in: header)
        id = try findColumn("id", in: header)
        participantTimestamp = try findColumn("participant_timestamp", in: header)
        price = try findColumn("price", in: header)
        sequenceNumber = try findColumn("sequence_number", in: header)
        sipTimestamp = try findColumn("sip_timestamp", in: header)
        size = try findColumn("size", in: header)
        tape = try findColumn("tape", in: header)
        trfId = try findColumn("trf_id", in: header)
        trfTimestamp = try findColumn("trf_timestamp", in: header)
        maxIndex = max(ticker, conditions, correction, exchange, id, participantTimestamp,
                       price, sequenceNumber, sipTimestamp, size, tape, trfId, trfTimestamp)
    }
}

// MARK: - Quote Indices

/// Column indices for quote CSV parsing.
struct QuoteIndices {
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

    init(header: [ArraySlice<UInt8>]) throws {
        ticker = try findColumn("ticker", in: header)
        askExchange = try findColumn("ask_exchange", in: header)
        askPrice = try findColumn("ask_price", in: header)
        askSize = try findColumn("ask_size", in: header)
        bidExchange = try findColumn("bid_exchange", in: header)
        bidPrice = try findColumn("bid_price", in: header)
        bidSize = try findColumn("bid_size", in: header)
        conditions = try findColumn("conditions", in: header)
        indicators = try findColumn("indicators", in: header)
        participantTimestamp = try findColumn("participant_timestamp", in: header)
        sequenceNumber = try findColumn("sequence_number", in: header)
        sipTimestamp = try findColumn("sip_timestamp", in: header)
        tape = try findColumn("tape", in: header)
        trfTimestamp = try findColumn("trf_timestamp", in: header)
        maxIndex = max(ticker, askExchange, askPrice, askSize, bidExchange, bidPrice, bidSize,
                       conditions, indicators, participantTimestamp, sequenceNumber, sipTimestamp, tape, trfTimestamp)
    }
}
