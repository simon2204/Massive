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
    .package(url: "https://github.com/simon2204/Massive.git", branch: "main")
]
```

### REST API Quick Start

@Snippet(path: "Massive/Snippets/RESTQuickstart")

### Flat Files Quick Start

For bulk historical data, use the S3 client with the typed API:

@Snippet(path: "Massive/Snippets/S3Quickstart")

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:AdvancedTopics>
- <doc:FlatFiles>

### REST API

- ``MassiveClient``
- ``MassiveError``

### WebSocket

- ``MassiveWebSocket``

### S3 Flat Files

- ``S3Client``
- ``S3Credentials``
- ``FlatFileParser``

