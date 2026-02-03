# Massive

A Swift client for the Massive API providing access to financial market data.

## Features

- News articles with sentiment analysis
- Historical OHLC bar data with customizable time intervals
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
// Fetch news for a specific ticker
let news = try await client.news(NewsQuery(ticker: "AAPL", limit: 10))
for article in news.results {
    print("\(article.title) - \(article.publisher.name)")
}

// Fetch news with date filtering
let query = NewsQuery(
    publishedUtcGte: "2024-01-01",
    publishedUtcLte: "2024-01-31",
    order: .desc
)
let news = try await client.news(query)
```

### Fetching Bar Data

```swift
// Fetch daily bars
let bars = try await client.bars(BarsQuery(
    ticker: "AAPL",
    from: "2024-01-01",
    to: "2024-01-31"
))
for bar in bars.results ?? [] {
    print("Open: \(bar.o), Close: \(bar.c)")
}

// Fetch 5-minute bars
let minuteBars = try await client.bars(BarsQuery(
    ticker: "AAPL",
    multiplier: 5,
    timespan: .minute,
    from: "2024-01-15",
    to: "2024-01-15"
))
```

### Pagination

For endpoints that return paginated results, use the `allNews` or `allBars` methods to automatically iterate through all pages:

```swift
for try await page in client.allNews(NewsQuery(ticker: "AAPL")) {
    for article in page.results {
        print(article.title)
    }
}

for try await page in client.allBars(BarsQuery(
    ticker: "AAPL",
    timespan: .minute,
    from: "2024-01-01",
    to: "2024-01-31"
)) {
    for bar in page.results ?? [] {
        print(bar.c)
    }
}
```

### Rate Limiting

You can configure a rate limiter to control request frequency:

```swift
let client = MassiveClient(
    apiKey: "your-api-key",
    rateLimiter: RateLimiter(requestsPerSecond: 5)
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

## API Reference

### MassiveClient

The main client for interacting with the Massive API.

**Methods:**
- `news(_:)` - Fetch news articles
- `bars(_:)` - Fetch OHLC bar data
- `allNews(_:)` - Paginated news iterator
- `allBars(_:)` - Paginated bars iterator

### NewsQuery

Query parameters for the news endpoint.

| Parameter | Type | Description |
|-----------|------|-------------|
| `ticker` | `String?` | Filter by ticker symbol |
| `publishedUtc` | `String?` | Filter by publication date |
| `publishedUtcGte` | `String?` | Published on or after |
| `publishedUtcLte` | `String?` | Published on or before |
| `order` | `Order?` | Sort order (`.asc` or `.desc`) |
| `limit` | `Int?` | Max results (default 10, max 1000) |

### BarsQuery

Query parameters for the bars endpoint.

| Parameter | Type | Description |
|-----------|------|-------------|
| `ticker` | `String` | Ticker symbol (required) |
| `multiplier` | `Int` | Timespan multiplier (default 1) |
| `timespan` | `Timespan` | Time interval (`.minute`, `.hour`, `.day`, etc.) |
| `from` | `String` | Start date (YYYY-MM-DD or timestamp) |
| `to` | `String` | End date (YYYY-MM-DD or timestamp) |
| `adjusted` | `Bool?` | Adjust for splits (default true) |
| `sort` | `Sort?` | Sort order |
| `limit` | `Int?` | Max aggregates (default 5000, max 50000) |

## Requirements

- Swift 6.0+
- macOS 10.15+ / iOS 13+ / tvOS 13+ / watchOS 6+

## License

MIT
