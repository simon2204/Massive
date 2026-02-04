# Getting Started

Set up the Massive client and make your first API requests.

## Overview

This guide walks you through setting up the Massive client, fetching market news, and retrieving historical price data.

## Prerequisites

You'll need a Massive API key. Get one from the [Massive Dashboard](https://massive.com/dashboard).

## Creating a Client

Initialize ``MassiveClient`` with your API key:

@Snippet(path: "Massive/Snippets/GettingStartedExamples", slice: "create-client")

The client handles authentication, rate limiting, and automatic retries.

### Configuration Options

For advanced use cases, you can customize the client:

@Snippet(path: "Massive/Snippets/GettingStartedExamples", slice: "client-config")

## Fetching News

Use ``NewsQuery`` to search for market news:

@Snippet(path: "Massive/Snippets/FetchingNews")

## Fetching Historical Bars

Use ``BarsQuery`` to retrieve OHLC (Open, High, Low, Close) data:

@Snippet(path: "Massive/Snippets/FetchingBars")

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

All REST endpoints return lazy `AsyncSequence` that automatically paginates:

@Snippet(path: "Massive/Snippets/GettingStartedExamples", slice: "pagination")

Pages are only fetched as you iterate, so breaking early avoids unnecessary requests.

## Error Handling

The client throws ``MassiveError`` for API errors:

@Snippet(path: "Massive/Snippets/GettingStartedExamples", slice: "error-handling")

## Technical Indicators

Calculate technical analysis indicators like SMA, RSI, and MACD:

@Snippet(path: "Massive/Snippets/TechnicalIndicators")

## Real-Time Streaming

For real-time market data, use the WebSocket API:

@Snippet(path: "Massive/Snippets/WebSocketStreaming")

## Next Steps

- <doc:FlatFiles> - Download bulk historical data via S3
- <doc:AdvancedTopics> - Fundamentals, Corporate Actions, Economy Data
