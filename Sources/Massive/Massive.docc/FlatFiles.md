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

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "create-s3-client")

## Quick Start

Here's a complete example that downloads daily stock data and finds the top gainers:

@Snippet(path: "Massive/Snippets/FlatFiles")

## Downloading and Parsing Data

The simplest way to get market data is with the typed API, which downloads, decompresses, and parses in one step:

### Minute Aggregates

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "minute-aggregates")

### Day Aggregates

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "day-aggregates")

### Trades

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "trades")

### Quotes

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "quotes")

## Working with Data Models

### Filtering by Ticker

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "filter-by-ticker")

### Using Timestamps

The ``MinuteAggregate/windowStart`` property is a `Timestamp` with nanosecond precision:

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "timestamps")

### Analyzing Trades

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "block-trades")

### Working with Quotes

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "spreads")

## Listing Files

### List by Asset Class and Data Type

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "list-files")

### List with Custom Prefix

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "list-prefix")

### Handle Pagination

For directories with many files:

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "list-paginated")

## Downloading Raw Files

If you need the raw gzip-compressed CSV data:

### Download to Memory

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "download-memory")

### Download to Disk

For larger files, stream directly to disk to avoid memory pressure:

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "download-disk")

### Download by Key

If you know the exact file path:

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "download-key")

## Checking File Existence

Use ``S3Client/head(key:)`` to check if a file exists without downloading:

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "head")

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

@Snippet(path: "Massive/Snippets/FlatFilesExamples", slice: "error-handling")

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
