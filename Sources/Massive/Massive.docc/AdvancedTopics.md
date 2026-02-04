# Advanced Topics

Access fundamentals, corporate actions, economic indicators, and market snapshots.

## Overview

Beyond basic price data, Massive provides comprehensive financial data including company fundamentals, corporate events, macroeconomic indicators, and real-time market snapshots.

## Company Fundamentals

Access financial statements and ratios from SEC filings:

@Snippet(path: "Massive/Snippets/Fundamentals")

### Available Fundamentals

| Endpoint | Description |
|----------|-------------|
| `incomeStatements` | Revenue, expenses, net income |
| `balanceSheets` | Assets, liabilities, equity |
| `cashFlowStatements` | Operating, investing, financing cash flows |
| `ratios` | P/E, ROE, debt ratios |
| `shortInterest` | Short selling data |
| `float` | Shares available for trading |

## Corporate Actions

Track dividends, splits, and IPOs:

@Snippet(path: "Massive/Snippets/CorporateActions")

### IPO Status Options

Filter upcoming IPOs by status:

| Status | Description |
|--------|-------------|
| `.pending` | IPO is scheduled but not yet priced |
| `.priced` | IPO has been priced |
| `.withdrawn` | IPO was cancelled |

## Economic Indicators

Access macroeconomic data from Federal Reserve sources:

@Snippet(path: "Massive/Snippets/Economy")

### Available Indicators

| Endpoint | Data |
|----------|------|
| `treasuryYields` | Yield curve from 1M to 30Y |
| `inflation` | CPI, PCE, Core inflation |
| `inflationExpectations` | Breakeven rates, model forecasts |
| `laborMarket` | Unemployment, job openings, wages |

## Market Snapshots

Get real-time market data and top movers:

@Snippet(path: "Massive/Snippets/Snapshots")

### Snapshot Types

| Method | Description |
|--------|-------------|
| `tickerSnapshot` | Single ticker with full details |
| `marketSnapshot` | All tickers or a filtered list |
| `universalSnapshot` | Mixed asset types in one request |
| `topMovers` | Top 20 gainers or losers |

## See Also

- <doc:GettingStarted>
- <doc:FlatFiles>
