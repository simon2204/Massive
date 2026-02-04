import Fetch

extension Timestamp {
    /// Milliseconds since Unix epoch.
    @inlinable @inline(__always)
    public var millisecondsSinceEpoch: Int64 {
        nanosecondsSinceEpoch / 1_000_000
    }

    /// Creates a timestamp from milliseconds since epoch.
    @inlinable @inline(__always)
    public init(millisecondsSinceEpoch: Int64) {
        self.init(nanosecondsSinceEpoch: millisecondsSinceEpoch * 1_000_000)
    }
}
