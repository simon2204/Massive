# Flat Files

Download bulk historical market data via S3-compatible storage.

## Overview

Massive Flat Files provide compressed CSV files containing historical market data. This is more efficient than making individual REST API requests when you need large datasets.

Data is organized by:
- **Asset Class**: ``AssetClass/usStocks``, ``AssetClass/usOptions``, ``AssetClass/indices``, ``AssetClass/forex``, ``AssetClass/crypto``
- **Data Type**: ``DataType/trades``, ``DataType/quotes``, ``DataType/minuteAggregates``, ``DataType/dayAggregates``
- **Date**: Files are organized by year and month

## Prerequisites

You need S3 credentials (separate from your API key). Get them from the [Massive Dashboard](https://massive.com/dashboard).

## Creating an S3 Client

```swift
import Massive

let credentials = S3Credentials(
    accessKeyId: "your-access-key",
    secretAccessKey: "your-secret-key"
)

let s3 = S3Client.massiveFlatFiles(credentials: credentials)
```

## Downloading and Parsing Data

The simplest way to get market data is with the typed API, which downloads, decompresses, and parses in one step:

### Minute Aggregates

```swift
let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")

for bar in bars {
    print("\(bar.ticker): O=\(bar.open) H=\(bar.high) L=\(bar.low) C=\(bar.close) V=\(bar.volume)")
}
```

### Day Aggregates

```swift
let dailyBars = try await s3.dayAggregates(for: .usStocks, date: "2025-01-15")
```

### Trades

```swift
let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")

for trade in trades {
    print("\(trade.ticker) @ \(trade.price) x \(trade.size)")
}
```

### Quotes

```swift
let quotes = try await s3.quotes(for: .usStocks, date: "2025-01-15")

for quote in quotes {
    print("\(quote.ticker): \(quote.bidPrice) / \(quote.askPrice)")
}
```

## Listing Files

### List by Asset Class and Data Type

```swift
let result = try await s3.listFlatFiles(
    assetClass: .usStocks,
    dataType: .minuteAggregates,
    year: 2025,
    month: 1
)

for file in result.objects {
    print("\(file.key) - \(file.size) bytes")
}
```

### List with Custom Prefix

```swift
let result = try await s3.list(prefix: "us_stocks_sip/trades_v1/2025/")
```

### Handle Pagination

For directories with many files:

```swift
for try await page in s3.listAll(prefix: "us_stocks_sip/") {
    for file in page.objects {
        print(file.key)
    }
}
```

## Downloading Raw Files

If you need the raw gzip-compressed CSV data:

### Download to Memory

```swift
let data = try await s3.downloadFlatFile(
    assetClass: .usStocks,
    dataType: .minuteAggregates,
    date: "2025-01-02"
)
// data is gzip-compressed CSV
```

### Download to Disk

For larger files, stream directly to disk to avoid memory pressure:

```swift
let destination = URL(filePath: "/path/to/file.csv.gz")

try await s3.downloadFlatFile(
    assetClass: .usStocks,
    dataType: .minuteAggregates,
    date: "2025-01-02",
    to: destination
)
```

### Download by Key

If you know the exact file path:

```swift
let data = try await s3.download(
    key: "us_stocks_sip/minute_aggs_v1/2025/01/2025-01-02.csv.gz"
)
```

## Checking File Existence

Use ``S3Client/head(key:)`` to check if a file exists without downloading:

```swift
if let metadata = try await s3.head(key: "us_stocks_sip/minute_aggs_v1/2025/01/2025-01-02.csv.gz") {
    print("Size: \(metadata.size) bytes")
    print("ETag: \(metadata.etag ?? "unknown")")
} else {
    print("File not found")
}
```

## Available Data

### Asset Classes

| Asset Class | Description |
|-------------|-------------|
| `us_stocks_sip` | US Stocks (SIP consolidated feed) |
| `us_options_opra` | US Options (OPRA feed) |
| `indices` | Market indices |
| `forex` | Foreign exchange |
| `crypto` | Cryptocurrencies |

### Data Types

| Data Type | Description |
|-----------|-------------|
| `trades_v1` | Individual trades |
| `quotes_v1` | Bid/ask quotes |
| `minute_aggs_v1` | Minute OHLCV bars |
| `day_aggs_v1` | Daily OHLCV bars |

## File Format

Files are gzip-compressed CSV with a header row. Example minute aggregate:

```csv
ticker,volume,open,close,high,low,window_start,transactions
AAPL,4930,200.29,200.5,200.63,200.29,1744792500000000000,129
```

Data for each trading day is typically available by 11:00 AM ET the following day.

## Error Handling

```swift
do {
    let data = try await s3.download(key: "nonexistent.csv.gz")
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
```

## See Also

### Client
- ``S3Client``
- ``S3Credentials``

### Types
- ``AssetClass``
- ``DataType``

### Data Models
- ``MinuteAggregate``
- ``DayAggregate``
- ``Trade``
- ``Quote``

### Parsing
- ``FlatFileParser``

### S3 Types
- ``S3ListResult``
- ``S3Object``
