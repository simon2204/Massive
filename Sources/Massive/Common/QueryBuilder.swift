import Fetch
import Foundation

/// A builder for constructing URL query items.
///
/// Provides helpers for adding optional parameters to API queries,
/// automatically skipping nil values.
///
/// ## Usage
///
/// ```swift
/// var queryItems: [URLQueryItem]? {
///     var builder = QueryBuilder()
///     builder.add("ticker", ticker)
///     builder.add("limit", limit)
///     builder.add("order", order)
///     builder.add("adjusted", adjusted)
///     return builder.build()
/// }
/// ```
public struct QueryBuilder: Sendable {
    private var items: [URLQueryItem] = []

    public init() {}

    /// Adds a string parameter if not nil.
    public mutating func add(_ name: String, _ value: String?) {
        if let value {
            items.append(URLQueryItem(name: name, value: value))
        }
    }

    /// Adds an integer parameter if not nil.
    public mutating func add(_ name: String, _ value: Int?) {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value)))
        }
    }

    /// Adds a boolean parameter if not nil.
    public mutating func add(_ name: String, _ value: Bool?) {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value)))
        }
    }

    /// Adds a double parameter if not nil.
    public mutating func add(_ name: String, _ value: Double?) {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value)))
        }
    }

    /// Adds a RawRepresentable parameter (enum) if not nil.
    public mutating func add<T: RawRepresentable>(_ name: String, _ value: T?) where T.RawValue == String {
        if let value {
            items.append(URLQueryItem(name: name, value: value.rawValue))
        }
    }

    /// Adds a Ticker parameter if not nil.
    public mutating func add(_ name: String, _ value: Ticker?) {
        if let value {
            items.append(URLQueryItem(name: name, value: value.symbol))
        }
    }

    /// Adds a Timestamp parameter if not nil (as milliseconds since epoch).
    public mutating func add(_ name: String, _ value: Timestamp?) {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value.millisecondsSinceEpoch)))
        }
    }

    /// Returns the built query items, or nil if empty.
    public func build() -> [URLQueryItem]? {
        items.isEmpty ? nil : items
    }
}
