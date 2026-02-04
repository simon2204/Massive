import Foundation

/// Errors that can occur when parsing flat files.
public enum FlatFileError: Error {
    /// The data is invalid or corrupted.
    case invalidData
    /// A required column is missing from the CSV.
    case missingColumn(String)
}
