// snippet.hide
import Foundation
import Massive

func examples() async throws {
    // snippet.show

    // snippet.create-s3-client
    import Massive

    let credentials = S3Credentials(
        accessKeyId: "your-access-key",
        secretAccessKey: "your-secret-key"
    )

    let s3 = S3Client.massiveFlatFiles(credentials: credentials)
    // snippet.end

    // snippet.minute-aggregates
    let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")

    for bar in bars {
        print("\(bar.ticker): O=\(bar.open) H=\(bar.high) L=\(bar.low) C=\(bar.close) V=\(bar.volume)")
    }
    // snippet.end

    // snippet.day-aggregates
    let dailyBars = try await s3.dayAggregates(for: .usStocks, date: "2025-01-15")
    // snippet.end

    // snippet.trades
    let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")

    for trade in trades {
        print("\(trade.ticker) @ \(trade.price) x \(trade.size)")
    }
    // snippet.end

    // snippet.quotes
    let quotes = try await s3.quotes(for: .usStocks, date: "2025-01-15")

    for quote in quotes {
        print("\(quote.ticker): \(quote.bidPrice) / \(quote.askPrice)")
    }
    // snippet.end

    // snippet.filter-by-ticker
    let allBars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")

    // Get all Apple bars
    let aaplBars = allBars.filter { $0.ticker == "AAPL" }

    // Calculate VWAP (Volume Weighted Average Price)
    let totalValue = aaplBars.reduce(0.0) { $0 + $1.close * Double($1.volume) }
    let totalVolume = aaplBars.reduce(0) { $0 + $1.volume }
    let vwap = totalValue / Double(totalVolume)
    // snippet.end

    // snippet.timestamps
    for bar in aaplBars {
        // Get the timestamp as a formatted string
        print("\(bar.windowStart): \(bar.close)")
        
        // Access raw nanoseconds since epoch
        let nanos = bar.windowStart.nanosecondsSinceEpoch
        
        // Arithmetic with Duration
        let fiveMinutesLater = bar.windowStart + .seconds(300)
    }
    // snippet.end

    // snippet.block-trades
    let allTrades = try await s3.trades(for: .usStocks, date: "2025-01-15")

    // Filter for large block trades (10,000+ shares)
    let blockTrades = allTrades.filter { $0.size >= 10_000 }

    // Group by ticker
    let tradesByTicker = Dictionary(grouping: blockTrades) { $0.ticker }

    for (ticker, tickerTrades) in tradesByTicker.prefix(5) {
        let totalVolume = tickerTrades.reduce(0) { $0 + $1.size }
        print("\(ticker): \(tickerTrades.count) block trades, \(totalVolume) shares")
    }
    // snippet.end

    // snippet.spreads
    let allQuotes = try await s3.quotes(for: .usStocks, date: "2025-01-15")

    // Calculate bid-ask spreads
    let aaplQuotes = allQuotes.filter { $0.ticker == "AAPL" }
    let avgSpread = aaplQuotes.reduce(0.0) { $0 + ($1.askPrice - $1.bidPrice) } / Double(aaplQuotes.count)
    print("AAPL average spread: $\(String(format: "%.4f", avgSpread))")
    // snippet.end

    // snippet.list-files
    let result = try await s3.listFlatFiles(
        assetClass: .usStocks,
        dataType: .minuteAggregates,
        year: 2025,
        month: 1
    )

    for file in result.objects {
        print("\(file.key) - \(file.size) bytes")
    }
    // snippet.end

    // snippet.list-prefix
    let prefixResult = try await s3.list(prefix: "us_stocks_sip/trades_v1/2025/")
    // snippet.end

    // snippet.list-paginated
    for try await page in s3.listAll(prefix: "us_stocks_sip/") {
        for file in page.objects {
            print(file.key)
        }
    }
    // snippet.end

    // snippet.download-memory
    let data = try await s3.downloadFlatFile(
        assetClass: .usStocks,
        dataType: .minuteAggregates,
        date: "2025-01-02"
    )
    // data is gzip-compressed CSV
    // snippet.end

    // snippet.download-disk
    let destination = URL(filePath: "/path/to/file.csv.gz")

    try await s3.downloadFlatFile(
        assetClass: .usStocks,
        dataType: .minuteAggregates,
        date: "2025-01-02",
        to: destination
    )
    // snippet.end

    // snippet.download-key
    let keyData = try await s3.download(
        key: "us_stocks_sip/minute_aggs_v1/2025/01/2025-01-02.csv.gz"
    )
    // snippet.end

    // snippet.head
    if let metadata = try await s3.head(key: "us_stocks_sip/minute_aggs_v1/2025/01/2025-01-02.csv.gz") {
        print("Size: \(metadata.size) bytes")
        print("ETag: \(metadata.etag ?? "unknown")")
    } else {
        print("File not found")
    }
    // snippet.end

    // snippet.error-handling
    do {
        let errorData = try await s3.download(key: "nonexistent.csv.gz")
    } catch let error as S3Error {
        switch error {
        case .notFound(let key):
            print("File not found: \(key)")
        case .httpError(let statusCode, let message):
            print("HTTP \(statusCode): \(message ?? "unknown")")
        case .invalidResponse:
            print("Invalid response")
        case .xmlParseError(let details):
            print("XML parse error: \(details)")
        }
    }
    // snippet.end

    // snippet.hide
}
