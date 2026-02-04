# ``Massive``

A Swift client for the Massive API providing access to financial market data.

## Overview

Massive is a Swift package that provides a type-safe interface to the Massive API. It supports:

- **REST API**: Market news with sentiment analysis and historical OHLC bar data
- **Flat Files**: Bulk historical data via S3-compatible storage

The library is designed with Swift 6 concurrency in mind, using `async`/`await` throughout and ensuring all types are `Sendable`.

## Getting Started

Add Massive to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/Massive.git", from: "1.0.0")
]
```

### REST API Quick Start

```swift
import Massive

let client = MassiveClient(apiKey: "your-api-key")

// Fetch news for a ticker
let news = try await client.news(NewsQuery(ticker: "AAPL", limit: 10))
for article in news.results {
    print(article.title)
}

// Fetch daily bars
let bars = try await client.bars(BarsQuery(
    ticker: "AAPL",
    from: "2024-01-01",
    to: "2024-01-31"
))
for bar in bars.results ?? [] {
    print("Close: \(bar.c)")
}
```

### Flat Files Quick Start

For bulk historical data, use the S3 client with the typed API:

```swift
import Massive

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
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:FlatFiles>

### REST API Client

- ``MassiveClient``
- ``MassiveError``

### News

- ``NewsQuery``
- ``NewsResponse``
- ``NewsArticle``

### Bars (OHLC Data)

- ``BarsQuery``
- ``BarsResponse``
- ``Bar``

### S3 Flat Files

- ``S3Client``
- ``S3Credentials``
- ``S3ListResult``
- ``S3Object``
- ``S3ObjectMetadata``
- ``S3Error``

### Flat File Types

- ``AssetClass``
- ``DataType``

### Flat File Data Models

- ``MinuteAggregate``
- ``DayAggregate``
- ``Trade``
- ``Quote``

### Parsing

- ``FlatFileParser``

### Protocols

- ``APIQuery``
- ``PaginatedResponse``

### Pagination

- ``PaginationCursor``
