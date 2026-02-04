# Massive

A Swift client for the Massive API providing access to financial market data.

## Features

- **REST API**: Stock market data, economic indicators, technical analysis, fundamentals, and more
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

## Quick Start

### REST API

```swift
import Massive

let client = MassiveClient(apiKey: "your-api-key")

// Fetch historical bars
for try await page in client.bars(BarsQuery(ticker: "AAPL", from: "2024-01-01", to: "2024-01-31")) {
    for bar in page.results ?? [] {
        print("Open: \(bar.open), Close: \(bar.close)")
    }
}

// Get real-time snapshot
let snapshot = try await client.tickerSnapshot(SingleTickerSnapshotQuery(ticker: "AAPL"))

// Technical indicators
let sma = try await client.sma(SMAQuery(ticker: "AAPL", window: 50))

// Fundamentals
let income = try await client.incomeStatements(IncomeStatementsQuery(tickers: "AAPL"))

// Economic data
let yields = try await client.treasuryYields(TreasuryYieldsQuery())
```

### WebSocket Streaming

```swift
let ws = MassiveWebSocket(apiKey: "your-api-key")

try await ws.subscribe(.trades(["AAPL", "GOOGL"]))

for try await message in ws.stream() {
    switch message {
    case .trade(let trade):
        print("\(trade.symbol): \(trade.price)")
    case .quote(let quote):
        print("\(quote.symbol): \(quote.bidPrice) / \(quote.askPrice)")
    default:
        break
    }
}
```

### S3 Flat Files

```swift
let s3 = S3Client.massiveFlatFiles(credentials: S3Credentials(
    accessKeyId: "your-access-key",
    secretAccessKey: "your-secret-key"
))

// Download and parse minute aggregates
let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")

// Download trades
let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")
```

## Documentation

For complete API documentation, build the DocC documentation in Xcode:

**Product → Build Documentation** (⌃⇧⌘D)

The documentation includes:
- Getting Started guide
- Advanced Topics (Fundamentals, Corporate Actions, Economy, Snapshots)
- Flat Files guide for bulk data downloads
- Full API reference

## Requirements

- Swift 6.2+
- macOS 26+ / iOS 26+ / tvOS 26+ / watchOS 26+ / visionOS 26+

## License

MIT
