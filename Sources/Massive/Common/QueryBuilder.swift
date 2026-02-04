import Foundation

/// A builder for constructing URL query items.
///
/// Provides a fluent interface for adding optional parameters to API queries,
/// reducing boilerplate code.
///
/// ## Usage
///
/// ```swift
/// var queryItems: [URLQueryItem]? {
///     QueryBuilder()
///         .add("ticker", ticker)
///         .add("limit", limit)
///         .add("order", order)
///         .add("adjusted", adjusted)
///         .build()
/// }
/// ```
public struct QueryBuilder: Sendable {
    private var items: [URLQueryItem] = []

    public init() {}

    /// Adds a string parameter if not nil.
    @discardableResult
    public mutating func add(_ name: String, _ value: String?) -> Self {
        if let value {
            items.append(URLQueryItem(name: name, value: value))
        }
        return self
    }

    /// Adds an integer parameter if not nil.
    @discardableResult
    public mutating func add(_ name: String, _ value: Int?) -> Self {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value)))
        }
        return self
    }

    /// Adds a boolean parameter if not nil.
    @discardableResult
    public mutating func add(_ name: String, _ value: Bool?) -> Self {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value)))
        }
        return self
    }

    /// Adds a double parameter if not nil.
    @discardableResult
    public mutating func add(_ name: String, _ value: Double?) -> Self {
        if let value {
            items.append(URLQueryItem(name: name, value: String(value)))
        }
        return self
    }

    /// Adds a RawRepresentable parameter (enum) if not nil.
    @discardableResult
    public mutating func add<T: RawRepresentable>(_ name: String, _ value: T?) -> Self where T.RawValue == String {
        if let value {
            items.append(URLQueryItem(name: name, value: value.rawValue))
        }
        return self
    }

    /// Adds a Ticker parameter if not nil.
    @discardableResult
    public mutating func add(_ name: String, _ value: Ticker?) -> Self {
        if let value {
            items.append(URLQueryItem(name: name, value: value.symbol))
        }
        return self
    }

    /// Returns the built query items, or nil if empty.
    public func build() -> [URLQueryItem]? {
        items.isEmpty ? nil : items
    }
}
