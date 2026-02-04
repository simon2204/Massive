import Foundation
import Testing
@testable import Massive

@Suite("FlatFileParser")
struct FlatFileParserTests {

    // MARK: - Minute Aggregates

    @Test("Parse minute aggregates CSV")
    func parseMinuteAggregates() throws {
        let csv = """
        ticker,volume,open,close,high,low,window_start,transactions
        AAPL,1000,150.25,151.50,152.00,150.00,1704067200000000000,50
        MSFT,2000,375.00,376.50,377.00,374.50,1704067200000000000,100
        """

        let aggregates = try FlatFileParser.parseMinuteAggregatesCSV(csv)

        #expect(aggregates.count == 2)

        let aapl = aggregates[0]
        #expect(aapl.ticker == "AAPL")
        #expect(aapl.volume == 1000)
        #expect(aapl.open == 150.25)
        #expect(aapl.close == 151.50)
        #expect(aapl.high == 152.00)
        #expect(aapl.low == 150.00)
        #expect(aapl.windowStart.nanosecondsSinceEpoch == 1704067200000000000)
        #expect(aapl.transactions == 50)

        let msft = aggregates[1]
        #expect(msft.ticker == "MSFT")
        #expect(msft.volume == 2000)
    }

    @Test("Parse minute aggregates with different column order")
    func parseMinuteAggregatesReorderedColumns() throws {
        let csv = """
        window_start,ticker,transactions,volume,high,low,open,close
        1704067200000000000,GOOG,25,500,100.50,99.50,100.00,100.25
        """

        let aggregates = try FlatFileParser.parseMinuteAggregatesCSV(csv)

        #expect(aggregates.count == 1)
        let goog = aggregates[0]
        #expect(goog.ticker == "GOOG")
        #expect(goog.volume == 500)
        #expect(goog.transactions == 25)
    }

    @Test("Parse empty minute aggregates CSV")
    func parseEmptyMinuteAggregates() throws {
        let csv = "ticker,volume,open,close,high,low,window_start,transactions"
        let aggregates = try FlatFileParser.parseMinuteAggregatesCSV(csv)
        #expect(aggregates.isEmpty)
    }

    // MARK: - Day Aggregates

    @Test("Parse day aggregates CSV")
    func parseDayAggregates() throws {
        let csv = """
        ticker,volume,open,close,high,low,window_start,transactions
        AAPL,10000000,150.00,155.00,156.00,149.00,1704067200000000000,500000
        """

        let aggregates = try FlatFileParser.parseDayAggregatesCSV(csv)

        #expect(aggregates.count == 1)
        let aapl = aggregates[0]
        #expect(aapl.ticker == "AAPL")
        #expect(aapl.volume == 10000000)
        #expect(aapl.open == 150.00)
        #expect(aapl.close == 155.00)
        #expect(aapl.transactions == 500000)
    }

    @Test("Parse real Massive day aggregates sample")
    func parseRealDayAggregatesSample() throws {
        // From https://massive.com/docs/examples/stocks_day_candlesticks_example.csv
        let csv = """
        ticker,volume,open,close,high,low,window_start,transactions
        BCC,248274,61.68,61.99,62.565,61.41,1680033600000000000,4073
        CLDX,882958,35.03,34.78,35.81,34.39,1680033600000000000,9971
        TRND,2084,26.73,26.7662,26.7662,26.7201,1680033600000000000,11
        BFS,47818,37.15,37.25,37.68,36.885,1680033600000000000,962
        NHTC,8284,4.9,4.85,4.92,4.85,1680033600000000000,107
        """

        let aggregates = try FlatFileParser.parseDayAggregatesCSV(csv)

        #expect(aggregates.count == 5)

        let bcc = aggregates[0]
        #expect(bcc.ticker == "BCC")
        #expect(bcc.volume == 248274)
        #expect(bcc.open == 61.68)
        #expect(bcc.close == 61.99)
        #expect(bcc.high == 62.565)
        #expect(bcc.low == 61.41)
        #expect(bcc.windowStart.nanosecondsSinceEpoch == 1680033600000000000)
        #expect(bcc.transactions == 4073)

        // Verify TRND has correct decimal precision
        let trnd = aggregates[2]
        #expect(trnd.ticker == "TRND")
        #expect(trnd.close == 26.7662)
    }

    @Test("Parse real Massive minute aggregates sample")
    func parseRealMinuteAggregatesSample() throws {
        // From https://massive.com/docs/examples/stocks_minute_candlesticks_example.csv
        let csv = """
        ticker,volume,open,close,high,low,window_start,transactions
        MSFT,1975,276.75,275.52,276.75,275.25,16799904000000000,83
        MSFT,2349,275.2,274.46,275.2,274.46,16799904600000000,99
        MSFT,1739,274.54,274.5,274.54,274.15,16799905200000000,55
        """

        let aggregates = try FlatFileParser.parseMinuteAggregatesCSV(csv)

        #expect(aggregates.count == 3)

        let first = aggregates[0]
        #expect(first.ticker == "MSFT")
        #expect(first.volume == 1975)
        #expect(first.open == 276.75)
        #expect(first.close == 275.52)
        #expect(first.transactions == 83)
    }

    // MARK: - Trades

    @Test("Parse trades CSV")
    func parseTrades() throws {
        let csv = """
        ticker,conditions,correction,exchange,id,participant_timestamp,price,sequence_number,sip_timestamp,size,tape,trf_id,trf_timestamp
        AAPL,12,0,4,abc123,1704067200000000000,150.25,1,1704067200000000001,100,1,,
        """

        let trades = try FlatFileParser.parseTradesCSV(csv)

        #expect(trades.count == 1)
        let trade = trades[0]
        #expect(trade.ticker == "AAPL")
        #expect(trade.conditions == [12])
        #expect(trade.correction == 0)
        #expect(trade.exchange == 4)
        #expect(trade.id == "abc123")
        #expect(trade.participantTimestamp.nanosecondsSinceEpoch == 1704067200000000000)
        #expect(trade.price == 150.25)
        #expect(trade.sequenceNumber == 1)
        #expect(trade.sipTimestamp.nanosecondsSinceEpoch == 1704067200000000001)
        #expect(trade.size == 100)
        #expect(trade.tape == .nyse)
        #expect(trade.trfId == nil)
        #expect(trade.trfTimestamp == nil)
    }

    @Test("Parse trades with multiple conditions")
    func parseTradesMultipleConditions() throws {
        let csv = """
        ticker,conditions,correction,exchange,id,participant_timestamp,price,sequence_number,sip_timestamp,size,tape,trf_id,trf_timestamp
        AAPL,"12, 37, 41",0,4,abc123,1704067200000000000,150.25,1,1704067200000000001,100,1,,
        """

        let trades = try FlatFileParser.parseTradesCSV(csv)

        #expect(trades.count == 1)
        #expect(trades[0].conditions == [12, 37, 41])
    }

    @Test("Parse trades with TRF data")
    func parseTradesWithTRF() throws {
        let csv = """
        ticker,conditions,correction,exchange,id,participant_timestamp,price,sequence_number,sip_timestamp,size,tape,trf_id,trf_timestamp
        AAPL,12,0,4,abc123,1704067200000000000,150.25,1,1704067200000000001,100,1,2,1704067200000000002
        """

        let trades = try FlatFileParser.parseTradesCSV(csv)

        #expect(trades.count == 1)
        let trade = trades[0]
        #expect(trade.trfId == 2)
        #expect(trade.trfTimestamp?.nanosecondsSinceEpoch == 1704067200000000002)
    }

    // MARK: - Quotes

    @Test("Parse quotes CSV")
    func parseQuotes() throws {
        let csv = """
        ticker,ask_exchange,ask_price,ask_size,bid_exchange,bid_price,bid_size,conditions,indicators,participant_timestamp,sequence_number,sip_timestamp,tape,trf_timestamp
        AAPL,4,150.50,1000,4,150.25,500,1,0,1704067200000000000,1,1704067200000000001,1,
        """

        let quotes = try FlatFileParser.parseQuotesCSV(csv)

        #expect(quotes.count == 1)
        let quote = quotes[0]
        #expect(quote.ticker == "AAPL")
        #expect(quote.askExchange == 4)
        #expect(quote.askPrice == 150.50)
        #expect(quote.askSize == 1000)
        #expect(quote.bidExchange == 4)
        #expect(quote.bidPrice == 150.25)
        #expect(quote.bidSize == 500)
        #expect(quote.conditions == [1])
        #expect(quote.indicators == [0])
        #expect(quote.participantTimestamp.nanosecondsSinceEpoch == 1704067200000000000)
        #expect(quote.sequenceNumber == 1)
        #expect(quote.sipTimestamp.nanosecondsSinceEpoch == 1704067200000000001)
        #expect(quote.tape == .nyse)
        #expect(quote.trfTimestamp == nil)
    }

    // MARK: - Decompression

    @Test("Decompress plain text (no gzip)")
    func decompressPlainText() throws {
        let text = "ticker,volume\nAAPL,100"
        let data = text.data(using: .utf8)!

        let result = try FlatFileParser.decompress(data)
        #expect(result == text)
    }

    // MARK: - Enums

    @Test("AssetClass raw values")
    func assetClassRawValues() {
        #expect(AssetClass.usStocks.rawValue == "us_stocks_sip")
        #expect(AssetClass.usOptions.rawValue == "us_options_opra")
        #expect(AssetClass.indices.rawValue == "indices")
        #expect(AssetClass.forex.rawValue == "forex")
        #expect(AssetClass.crypto.rawValue == "crypto")
    }

    @Test("DataType raw values")
    func dataTypeRawValues() {
        #expect(DataType.trades.rawValue == "trades_v1")
        #expect(DataType.quotes.rawValue == "quotes_v1")
        #expect(DataType.minuteAggregates.rawValue == "minute_aggs_v1")
        #expect(DataType.dayAggregates.rawValue == "day_aggs_v1")
    }
}
