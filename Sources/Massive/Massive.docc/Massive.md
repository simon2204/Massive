# ``Massive``

A Swift client for the Massive API providing access to financial market data.

## Overview

Massive is a Swift package that provides a type-safe interface to the Massive API. It supports fetching market news with sentiment analysis and historical OHLC (Open, High, Low, Close) bar data for stocks.

### Features

- News articles with sentiment analysis
- Historical OHLC bar data with customizable time intervals
- Automatic pagination support
- Rate limiting and retry logic
- Swift 6 concurrency support

### Quick Start

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

## Topics

### Client

- ``MassiveClient``
- ``MassiveError``

### News

- ``NewsQuery``
- ``NewsResponse``

### Bars

- ``BarsQuery``
- ``BarsResponse``

### Pagination

- ``PaginationCursor``
