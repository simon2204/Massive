import Foundation

/// A stock ticker symbol.
///
/// Provides type safety for ticker symbols and ensures consistent formatting.
///
/// ## Usage
///
/// ```swift
/// let ticker = Ticker("AAPL")
/// let query = BarsQuery(ticker: ticker, from: "2024-01-01", to: "2024-01-31")
/// ```
///
/// Tickers can also be created from string literals:
///
/// ```swift
/// let query = BarsQuery(ticker: "AAPL", from: "2024-01-01", to: "2024-01-31")
/// ```
public struct Ticker: Sendable, Hashable, Codable {
    /// The raw ticker symbol string.
    public let symbol: String

    /// Creates a ticker from a symbol string.
    ///
    /// - Parameter symbol: The ticker symbol (e.g., "AAPL", "MSFT").
    public init(_ symbol: String) {
        self.symbol = symbol
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.symbol = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(symbol)
    }
}

// MARK: - ExpressibleByStringLiteral

extension Ticker: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.symbol = value
    }
}

// MARK: - CustomStringConvertible

extension Ticker: CustomStringConvertible {
    public var description: String { symbol }
}
