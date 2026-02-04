# Massive

A Swift client for the Massive API providing access to financial market data.

## Features

- **REST API**: Comprehensive stock market data, economic indicators, technical analysis, and more
- **WebSocket Streaming**: Real-time trades, quotes, and aggregates
- **S3 Flat Files**: Bulk historical data via S3-compatible storage
- Automatic pagination support
- Rate limiting and retry logic
- Swift 6 concurrency support

## Installation

Add Massive to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://git.w-hs.de/Simon.Schoepke/massive.git", branch: "main")
]
```

Then add it as a dependency to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Massive"]
)
```

## Usage

### Creating a Client

```swift
import Massive

let client = MassiveClient(apiKey: "your-api-key")
```

### Fetching News

```swift
for try await page in client.news(NewsQuery(ticker: "AAPL", limit: 10)) {
    for article in page.results ?? [] {
        print("\(article.title) - \(article.publisher.name)")
    }
}
```

### Fetching Bar Data

```swift
for try await page in client.bars(BarsQuery(
    ticker: "AAPL",
    from: "2024-01-01",
    to: "2024-01-31"
)) {
    for bar in page.results ?? [] {
        print("Open: \(bar.o), Close: \(bar.c)")
    }
}
```

### Real-Time Snapshots

```swift
// Get current market data for a ticker
let snapshot = try await client.singleTickerSnapshot(SingleTickerSnapshotQuery(ticker: "AAPL"))
print("Current price: \(snapshot.ticker?.day?.c ?? 0)")

// Get top market movers
let gainers = try await client.topMovers(TopMoversQuery(direction: .gainers))
for mover in gainers.gainers ?? [] {
    print("\(mover.ticker ?? ""): +\(mover.todaysChangePerc ?? 0)%")
}
```

### Technical Indicators

```swift
// Simple Moving Average
let sma = try await client.sma(SMAQuery(ticker: "AAPL", window: 50))

// MACD
let macd = try await client.macd(MACDQuery(ticker: "AAPL"))

// RSI
let rsi = try await client.rsi(RSIQuery(ticker: "AAPL", window: 14))
```

### Fundamentals

```swift
// Balance sheets
let bs = try await client.balanceSheets(BalanceSheetsQuery(tickers: "AAPL"))

// Income statements
let income = try await client.incomeStatements(IncomeStatementsQuery(tickers: "AAPL"))

// Financial ratios
let ratios = try await client.ratios(RatiosQuery(ticker: "AAPL"))
```

### Corporate Actions

```swift
// Dividends
let dividends = try await client.dividends(DividendsQuery(ticker: "AAPL"))

// Stock splits
let splits = try await client.splits(SplitsQuery(ticker: "AAPL"))

// IPOs
let ipos = try await client.ipos(IPOsQuery())
```

### Economic Indicators

```swift
// Treasury yields
let yields = try await client.treasuryYields(TreasuryYieldsQuery())
for yield in yields.results ?? [] {
    print("\(yield.date ?? ""): 10Y=\(yield.yield10Year ?? 0)%")
}

// Inflation data
let inflation = try await client.inflation(InflationQuery())

// Labor market
let labor = try await client.laborMarket(LaborMarketQuery())
```

### WebSocket Streaming

Stream real-time market data with the WebSocket client:

```swift
let ws = MassiveWebSocket(apiKey: "your-api-key")

// Subscribe to trades and quotes for specific tickers
try await ws.subscribe(.trades(["AAPL", "GOOGL"]))
try await ws.subscribe(.quotes(["AAPL"]))

// Stream messages
for try await message in ws.stream() {
    switch message {
    case .trade(let trade):
        print("\(trade.symbol): \(trade.price) x \(trade.size)")
    case .quote(let quote):
        print("\(quote.symbol): \(quote.bidPrice) / \(quote.askPrice)")
    default:
        break
    }
}
```

Available subscription types:
- `.trades([String])` - Real-time trades
- `.quotes([String])` - Real-time quotes (NBBO)
- `.aggregatesPerSecond([String])` - Per-second aggregates
- `.aggregatesPerMinute([String])` - Per-minute aggregates

### Pagination

All paginated endpoints return lazy `AsyncSequence`. Pages are only fetched as you iterate:

```swift
for try await page in client.news(NewsQuery(ticker: "AAPL")) {
    for article in page.results ?? [] {
        print(article.title)
    }
    // Break early if you only need the first page
}
```

### Rate Limiting

You can configure a rate limiter to control request frequency:

```swift
let client = MassiveClient(
    apiKey: "your-api-key",
    rateLimiter: RateLimiter(requests: 5, per: .seconds(1))
)
```

### Retry Configuration

Configure automatic retries for failed requests:

```swift
let client = MassiveClient(
    apiKey: "your-api-key",
    retry: Retry(baseDelay: .seconds(1), maxAttempts: 3)
)
```

## S3 Flat Files

For bulk historical data, use the S3 client:

```swift
let s3 = S3Client.massiveFlatFiles(credentials: S3Credentials(
    accessKeyId: "your-access-key",
    secretAccessKey: "your-secret-key"
))

// Download and parse minute aggregates
let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")

for bar in bars.filter({ $0.ticker == "AAPL" }) {
    print("\(bar.windowStart): O=\(bar.open) C=\(bar.close) V=\(bar.volume)")
}

// Download and parse trades
let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")

// Download and parse quotes
let quotes = try await s3.quotes(for: .usStocks, date: "2025-01-15")
```

See the [Flat Files documentation](Sources/Massive/Massive.docc/FlatFiles.md) for more details.

## API Reference

### MassiveClient

The main client for interacting with the Massive API.

#### Stocks - Market Data

| Method | Description |
|--------|-------------|
| `news(_:)` | Fetch news articles (paginated) |
| `bars(_:)` | Fetch OHLC bar data (paginated) |
| `dailyMarketSummary(_:)` | Daily OHLC for entire market |
| `dailyTickerSummary(_:)` | Daily summary with extended hours |
| `previousDayBar(_:)` | Previous day's OHLC |

#### Stocks - Tickers

| Method | Description |
|--------|-------------|
| `tickers(_:)` | Fetch ticker list (paginated) |
| `tickerOverview(_:)` | Detailed ticker information |
| `tickerTypes(_:)` | Available ticker types |
| `relatedTickers(_:)` | Related tickers |

#### Stocks - Snapshots

| Method | Description |
|--------|-------------|
| `fullMarketSnapshot(_:)` | Snapshot of all tickers |
| `singleTickerSnapshot(_:)` | Snapshot for one ticker |
| `topMovers(_:)` | Top gainers/losers |
| `unifiedSnapshot(_:)` | Universal snapshot endpoint |

#### Stocks - Technical Indicators

| Method | Description |
|--------|-------------|
| `sma(_:)` | Simple Moving Average |
| `ema(_:)` | Exponential Moving Average |
| `macd(_:)` | MACD indicator |
| `rsi(_:)` | Relative Strength Index |

#### Stocks - Corporate Actions

| Method | Description |
|--------|-------------|
| `ipos(_:)` | IPO calendar |
| `splits(_:)` | Stock splits |
| `dividends(_:)` | Dividend history |
| `tickerEvents(_:)` | All corporate events |

#### Stocks - Fundamentals

| Method | Description |
|--------|-------------|
| `balanceSheets(_:)` | Balance sheet data |
| `cashFlowStatements(_:)` | Cash flow statements |
| `incomeStatements(_:)` | Income statements |
| `ratios(_:)` | Financial ratios |
| `shortInterest(_:)` | Short interest data |
| `shortVolume(_:)` | Daily short volume |
| `float(_:)` | Float data |

#### Stocks - SEC Filings

| Method | Description |
|--------|-------------|
| `tenKSections(_:)` | 10-K filing sections |
| `riskFactors(_:)` | Categorized risk factors |
| `riskCategories(_:)` | Risk factor taxonomy |

#### Stocks - Market Info

| Method | Description |
|--------|-------------|
| `exchanges(_:)` | Exchange information |
| `marketHolidays(_:)` | Market holidays |
| `marketStatus(_:)` | Current market status |
| `conditionCodes(_:)` | Trade/quote condition codes |

#### Economy

| Method | Description |
|--------|-------------|
| `treasuryYields(_:)` | Treasury yield curve |
| `inflation(_:)` | CPI and PCE data |
| `inflationExpectations(_:)` | Inflation expectations |
| `laborMarket(_:)` | Labor market indicators |

### S3Client

The client for downloading bulk historical data.

| Method | Description |
|--------|-------------|
| `minuteAggregates(for:date:)` | Download and parse minute aggregates |
| `dayAggregates(for:date:)` | Download and parse day aggregates |
| `trades(for:date:)` | Download and parse trades |
| `quotes(for:date:)` | Download and parse quotes |
| `listFlatFiles(assetClass:dataType:year:month:)` | List available files |
| `downloadFlatFile(assetClass:dataType:date:)` | Download raw compressed data |

### MassiveWebSocket

The client for streaming real-time market data.

| Method | Description |
|--------|-------------|
| `stream()` | Returns an `AsyncThrowingStream` of messages |
| `subscribe(_:)` | Subscribe to a data channel |
| `unsubscribe(_:)` | Unsubscribe from a channel |
| `disconnect()` | Close the connection |

#### Subscription Types

| Type | Description |
|------|-------------|
| `.trades([String])` | Real-time trade executions |
| `.quotes([String])` | Real-time NBBO quotes |
| `.aggregatesPerSecond([String])` | Per-second OHLCV bars |
| `.aggregatesPerMinute([String])` | Per-minute OHLCV bars |

## Requirements

- Swift 6.2+
- macOS 26+ / iOS 26+ / tvOS 26+ / watchOS 26+ / visionOS 26+

## License

MIT
