import Foundation

/// Column indices for minute aggregate CSV parsing.
struct MinuteAggregateIndices {
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
        func find(_ name: String) throws -> Int {
            let nameBytes = Array(name.utf8)
            guard let index = header.firstIndex(where: { $0.elementsEqual(nameBytes) }) else {
                throw FlatFileError.missingColumn(name)
            }
            return index
        }

        ticker = try find("ticker")
        volume = try find("volume")
        open = try find("open")
        close = try find("close")
        high = try find("high")
        low = try find("low")
        windowStart = try find("window_start")
        transactions = try find("transactions")
        maxIndex = max(ticker, volume, open, close, high, low, windowStart, transactions)
    }
}

/// Column indices for day aggregate CSV parsing.
struct DayAggregateIndices {
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
        func find(_ name: String) throws -> Int {
            let nameBytes = Array(name.utf8)
            guard let index = header.firstIndex(where: { $0.elementsEqual(nameBytes) }) else {
                throw FlatFileError.missingColumn(name)
            }
            return index
        }

        ticker = try find("ticker")
        volume = try find("volume")
        open = try find("open")
        close = try find("close")
        high = try find("high")
        low = try find("low")
        windowStart = try find("window_start")
        transactions = try find("transactions")
        maxIndex = max(ticker, volume, open, close, high, low, windowStart, transactions)
    }
}

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
        func find(_ name: String) throws -> Int {
            let nameBytes = Array(name.utf8)
            guard let index = header.firstIndex(where: { $0.elementsEqual(nameBytes) }) else {
                throw FlatFileError.missingColumn(name)
            }
            return index
        }

        ticker = try find("ticker")
        conditions = try find("conditions")
        correction = try find("correction")
        exchange = try find("exchange")
        id = try find("id")
        participantTimestamp = try find("participant_timestamp")
        price = try find("price")
        sequenceNumber = try find("sequence_number")
        sipTimestamp = try find("sip_timestamp")
        size = try find("size")
        tape = try find("tape")
        trfId = try find("trf_id")
        trfTimestamp = try find("trf_timestamp")
        maxIndex = max(ticker, conditions, correction, exchange, id, participantTimestamp,
                       price, sequenceNumber, sipTimestamp, size, tape, trfId, trfTimestamp)
    }
}

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
        func find(_ name: String) throws -> Int {
            let nameBytes = Array(name.utf8)
            guard let index = header.firstIndex(where: { $0.elementsEqual(nameBytes) }) else {
                throw FlatFileError.missingColumn(name)
            }
            return index
        }

        ticker = try find("ticker")
        askExchange = try find("ask_exchange")
        askPrice = try find("ask_price")
        askSize = try find("ask_size")
        bidExchange = try find("bid_exchange")
        bidPrice = try find("bid_price")
        bidSize = try find("bid_size")
        conditions = try find("conditions")
        indicators = try find("indicators")
        participantTimestamp = try find("participant_timestamp")
        sequenceNumber = try find("sequence_number")
        sipTimestamp = try find("sip_timestamp")
        tape = try find("tape")
        trfTimestamp = try find("trf_timestamp")
        maxIndex = max(ticker, askExchange, askPrice, askSize, bidExchange, bidPrice, bidSize,
                       conditions, indicators, participantTimestamp, sequenceNumber, sipTimestamp, tape, trfTimestamp)
    }
}
