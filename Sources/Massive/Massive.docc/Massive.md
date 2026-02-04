# ``Massive``

A Swift client for the Massive API providing access to financial market data.

## Overview

Massive is a Swift package that provides a type-safe interface to the Massive API. It supports:

- **REST API**: Comprehensive stock market data, economic indicators, and more
- **Flat Files**: Bulk historical data via S3-compatible storage

The library is designed with Swift 6 concurrency in mind, using `async`/`await` throughout and ensuring all types are `Sendable`.

## Getting Started

Add Massive to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://git.w-hs.de/Simon.Schoepke/massive.git", branch: "main")
]
```

### REST API Quick Start

```swift
import Massive

let client = MassiveClient(apiKey: "your-api-key")

// Fetch news for a ticker
for try await page in client.news(NewsQuery(ticker: "AAPL", limit: 10)) {
    for article in page.results ?? [] {
        print(article.title)
    }
}

// Fetch daily bars
for try await page in client.bars(BarsQuery(
    ticker: "AAPL",
    from: "2024-01-01",
    to: "2024-01-31"
)) {
    for bar in page.results ?? [] {
        print("Close: \(bar.c)")
    }
}

// Get current snapshot
let snapshot = try await client.singleTickerSnapshot(SingleTickerSnapshotQuery(ticker: "AAPL"))
print("Current price: \(snapshot.ticker?.day?.c ?? 0)")

// Fetch Treasury yields
let yields = try await client.treasuryYields(TreasuryYieldsQuery())
for yield in yields.results ?? [] {
    print("\(yield.date ?? ""): 10Y=\(yield.yield10Year ?? 0)%")
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
- <doc:AdvancedTopics>
- <doc:FlatFiles>

### REST API Client

- ``MassiveClient``
- ``MassiveError``

### Stocks - News

- ``NewsQuery``
- ``NewsResponse``

### Stocks - Bars (OHLC Data)

- ``BarsQuery``
- ``BarsResponse``
- ``DailyMarketSummaryQuery``
- ``DailyMarketSummaryResponse``
- ``DailyTickerSummaryQuery``
- ``DailyTickerSummaryResponse``
- ``PreviousDayBarQuery``
- ``PreviousDayBarResponse``

### Stocks - Tickers

- ``TickersQuery``
- ``TickersResponse``
- ``TickerOverviewQuery``
- ``TickerOverviewResponse``
- ``TickerTypesQuery``
- ``TickerTypesResponse``
- ``RelatedTickersQuery``
- ``RelatedTickersResponse``

### Stocks - Snapshots

- ``FullMarketSnapshotQuery``
- ``FullMarketSnapshotResponse``
- ``SingleTickerSnapshotQuery``
- ``SingleTickerSnapshotResponse``
- ``TopMoversQuery``
- ``TopMoversResponse``
- ``UnifiedSnapshotQuery``
- ``UnifiedSnapshotResponse``

### Stocks - Technical Indicators

- ``SMAQuery``
- ``SMAResponse``
- ``EMAQuery``
- ``EMAResponse``
- ``MACDQuery``
- ``MACDResponse``
- ``RSIQuery``
- ``RSIResponse``

### Stocks - Corporate Actions

- ``IPOsQuery``
- ``IPOsResponse``
- ``SplitsQuery``
- ``SplitsResponse``
- ``DividendsQuery``
- ``DividendsResponse``
- ``TickerEventsQuery``
- ``TickerEventsResponse``

### Stocks - Fundamentals

- ``BalanceSheetsQuery``
- ``BalanceSheetsResponse``
- ``CashFlowStatementsQuery``
- ``CashFlowStatementsResponse``
- ``IncomeStatementsQuery``
- ``IncomeStatementsResponse``
- ``RatiosQuery``
- ``RatiosResponse``
- ``ShortInterestQuery``
- ``ShortInterestResponse``
- ``ShortVolumeQuery``
- ``ShortVolumeResponse``
- ``FloatQuery``
- ``FloatResponse``

### Stocks - SEC Filings

- ``TenKSectionsQuery``
- ``TenKSectionsResponse``
- ``RiskFactorsQuery``
- ``RiskFactorsResponse``
- ``RiskCategoriesQuery``
- ``RiskCategoriesResponse``

### Stocks - Market Info

- ``ExchangesQuery``
- ``ExchangesResponse``
- ``MarketHolidaysQuery``
- ``MarketHolidaysResponse``
- ``MarketStatusQuery``
- ``MarketStatusResponse``
- ``ConditionCodesQuery``
- ``ConditionCodesResponse``

### Economy

- ``TreasuryYieldsQuery``
- ``TreasuryYieldsResponse``
- ``InflationQuery``
- ``InflationResponse``
- ``InflationExpectationsQuery``
- ``InflationExpectationsResponse``
- ``LaborMarketQuery``
- ``LaborMarketResponse``

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

### Common Types

- ``Ticker``
- ``SortOrder``
- ``Sentiment``
- ``QueryBuilder``

### Pagination

- ``PaginationCursor``
