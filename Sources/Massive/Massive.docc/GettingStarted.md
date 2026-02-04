# Getting Started

Set up the Massive client and make your first API requests.

## Overview

This guide walks you through setting up the Massive client, fetching market news, and retrieving historical price data.

## Prerequisites

You'll need a Massive API key. Get one from the [Massive Dashboard](https://massive.com/dashboard).

## Creating a Client

Initialize ``MassiveClient`` with your API key:

```swift
import Massive

let client = MassiveClient(apiKey: "your-api-key")
```

The client handles authentication, rate limiting, and automatic retries.

### Configuration Options

For advanced use cases, you can customize the client:

```swift
let client = MassiveClient(
    apiKey: "your-api-key",
    rateLimiter: RateLimiter(requests: 5, per: .seconds(1)),
    retry: Retry(baseDelay: .seconds(1), maxAttempts: 5)
)
```

## Fetching News

Use ``NewsQuery`` to search for market news:

```swift
let news = try await client.news(NewsQuery(
    ticker: "AAPL",
    publishedUtcGte: "2024-01-01",
    order: .desc,
    limit: 10
))

for article in news.results {
    print(article.title)
    
    // Access sentiment analysis if available
    if let insight = article.insights?.first {
        print("Sentiment: \(insight.sentiment ?? "unknown")")
    }
}
```

## Fetching Historical Bars

Use ``BarsQuery`` to retrieve OHLC (Open, High, Low, Close) data:

```swift
let bars = try await client.bars(BarsQuery(
    ticker: "AAPL",
    multiplier: 1,
    timespan: .day,
    from: "2024-01-01",
    to: "2024-01-31"
))

for bar in bars.results ?? [] {
    let date = Date(timeIntervalSince1970: Double(bar.t) / 1000)
    print("\(date): O=\(bar.o) H=\(bar.h) L=\(bar.l) C=\(bar.c) V=\(bar.v)")
}
```

### Time Intervals

The `timespan` parameter controls the bar interval:

| Timespan | Description |
|----------|-------------|
| `.minute` | 1-minute bars |
| `.hour` | Hourly bars |
| `.day` | Daily bars |
| `.week` | Weekly bars |
| `.month` | Monthly bars |

Use `multiplier` for custom intervals (e.g., `multiplier: 5` with `.minute` for 5-minute bars).

## Pagination

For endpoints that return many results, use the paginated methods:

```swift
for try await page in client.allNews(NewsQuery(ticker: "AAPL")) {
    for article in page.results {
        print(article.title)
    }
}
```

This automatically follows pagination links until all results are fetched.

## Error Handling

The client throws ``MassiveError`` for API errors:

```swift
do {
    let news = try await client.news(NewsQuery(ticker: "INVALID"))
} catch let error as MassiveError {
    switch error {
    case .httpError(let statusCode, let data):
        print("HTTP \(statusCode): \(String(data: data, encoding: .utf8) ?? "")")
    case .invalidResponse:
        print("Invalid response from server")
    }
}
```

## Next Steps

- <doc:FlatFiles> - Download bulk historical data via S3
