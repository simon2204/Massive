import Foundation

/// The tape identifier indicating which exchange a security is listed on.
///
/// The tape determines the primary listing exchange and affects trade reporting.
public enum Tape: Int, Sendable, Codable, CaseIterable {
    /// NYSE listed securities (Tape A).
    case nyse = 1

    /// NYSE American (formerly AMEX) and regional exchange listed securities (Tape B).
    case nyseAmerican = 2

    /// Nasdaq listed securities (Tape C).
    case nasdaq = 3
}

extension Tape: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nyse: "NYSE"
        case .nyseAmerican: "NYSE American"
        case .nasdaq: "Nasdaq"
        }
    }
}
