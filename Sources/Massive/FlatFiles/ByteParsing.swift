import Foundation
import SWCompression

/// Internal byte-level parsing utilities for CSV data.
/// Uses zero-copy parsing for optimal performance.
enum ByteParsing {

    // MARK: - ASCII Constants

    static let asciiNewline: UInt8 = 0x0A  // \n
    static let asciiCarriageReturn: UInt8 = 0x0D  // \r
    static let asciiComma: UInt8 = 0x2C  // ,
    static let asciiQuote: UInt8 = 0x22  // "
    static let asciiMinus: UInt8 = 0x2D  // -
    static let asciiDot: UInt8 = 0x2E  // .
    static let asciiZero: UInt8 = 0x30  // 0
    static let asciiNine: UInt8 = 0x39  // 9
    static let asciiSpace: UInt8 = 0x20  // space

    // MARK: - Decompression

    /// Decompresses gzip data to bytes, or returns raw bytes if not compressed.
    static func decompressToBytes(_ data: Data) throws -> [UInt8] {
        // Check for gzip magic number (0x1f, 0x8b)
        guard data.count >= 2, data[0] == 0x1f, data[1] == 0x8b else {
            // Not gzip, treat as plain data
            return Array(data)
        }

        do {
            let decompressed = try GzipArchive.unarchive(archive: data)
            return Array(decompressed)
        } catch {
            throw FlatFileError.invalidData
        }
    }

    // MARK: - Line Splitting

    /// Splits bytes into lines (handles \n and \r\n)
    static func splitLines(_ bytes: [UInt8]) -> [ArraySlice<UInt8>] {
        var lines: [ArraySlice<UInt8>] = []
        var start = 0
        var i = 0

        while i < bytes.count {
            if bytes[i] == asciiNewline {
                var end = i
                // Handle \r\n
                if end > start && bytes[end - 1] == asciiCarriageReturn {
                    end -= 1
                }
                if end > start {
                    lines.append(bytes[start..<end])
                }
                start = i + 1
            }
            i += 1
        }

        // Handle last line without newline
        if start < bytes.count {
            var end = bytes.count
            if bytes[end - 1] == asciiCarriageReturn {
                end -= 1
            }
            if end > start {
                lines.append(bytes[start..<end])
            }
        }

        return lines
    }

    // MARK: - Field Splitting

    /// Splits a line into fields (simple, no quote handling - for header and aggregates)
    static func splitFields(_ line: ArraySlice<UInt8>) -> [ArraySlice<UInt8>] {
        var fields: [ArraySlice<UInt8>] = []
        var start = line.startIndex
        var i = line.startIndex

        while i < line.endIndex {
            if line[i] == asciiComma {
                fields.append(line[start..<i])
                start = i + 1
            }
            i += 1
        }
        fields.append(line[start..<line.endIndex])

        return fields
    }

    /// Splits a line into fields (with quote handling - for trades/quotes)
    static func splitFieldsQuoted(_ line: ArraySlice<UInt8>) -> [ArraySlice<UInt8>] {
        var fields: [ArraySlice<UInt8>] = []
        var start = line.startIndex
        var i = line.startIndex
        var inQuotes = false

        while i < line.endIndex {
            let byte = line[i]
            if byte == asciiQuote {
                inQuotes.toggle()
            } else if byte == asciiComma && !inQuotes {
                fields.append(line[start..<i])
                start = i + 1
            }
            i += 1
        }
        fields.append(line[start..<line.endIndex])

        return fields
    }

    // MARK: - Number Parsing

    /// Parses an integer from ASCII bytes
    @inline(__always)
    static func intFromBytes(_ bytes: ArraySlice<UInt8>) -> Int {
        guard !bytes.isEmpty else { return 0 }

        var result = 0
        var negative = false
        var i = bytes.startIndex

        if bytes[i] == asciiMinus {
            negative = true
            i += 1
        }

        while i < bytes.endIndex {
            let digit = bytes[i]
            if digit >= asciiZero && digit <= asciiNine {
                result = result * 10 + Int(digit - asciiZero)
            }
            i += 1
        }

        return negative ? -result : result
    }

    /// Parses an Int64 from ASCII bytes
    @inline(__always)
    static func int64FromBytes(_ bytes: ArraySlice<UInt8>) -> Int64 {
        guard !bytes.isEmpty else { return 0 }

        var result: Int64 = 0
        var negative = false
        var i = bytes.startIndex

        if bytes[i] == asciiMinus {
            negative = true
            i += 1
        }

        while i < bytes.endIndex {
            let digit = bytes[i]
            if digit >= asciiZero && digit <= asciiNine {
                result = result * 10 + Int64(digit - asciiZero)
            }
            i += 1
        }

        return negative ? -result : result
    }

    /// Parses a Double from ASCII bytes
    @inline(__always)
    static func doubleFromBytes(_ bytes: ArraySlice<UInt8>) -> Double {
        guard !bytes.isEmpty else { return 0 }

        var intPart: Int64 = 0
        var fracPart: Int64 = 0
        var fracDivisor: Double = 1
        var negative = false
        var inFraction = false
        var i = bytes.startIndex

        if bytes[i] == asciiMinus {
            negative = true
            i += 1
        }

        while i < bytes.endIndex {
            let byte = bytes[i]
            if byte == asciiDot {
                inFraction = true
            } else if byte >= asciiZero && byte <= asciiNine {
                let digit = Int64(byte - asciiZero)
                if inFraction {
                    fracPart = fracPart * 10 + digit
                    fracDivisor *= 10
                } else {
                    intPart = intPart * 10 + digit
                }
            }
            i += 1
        }

        var result = Double(intPart) + Double(fracPart) / fracDivisor
        if negative { result = -result }
        return result
    }

    /// Checks if bytes contain at least one digit character.
    @inline(__always)
    private static func containsDigit(_ bytes: ArraySlice<UInt8>) -> Bool {
        for byte in bytes {
            if byte >= asciiZero && byte <= asciiNine {
                return true
            }
        }
        return false
    }

    /// Parses an optional integer from ASCII bytes.
    /// Returns nil if empty or contains no digits.
    @inline(__always)
    static func optionalIntFromBytes(_ bytes: ArraySlice<UInt8>) -> Int? {
        guard !bytes.isEmpty, containsDigit(bytes) else { return nil }
        return intFromBytes(bytes)
    }

    /// Parses an optional Int64 from ASCII bytes.
    /// Returns nil if empty or contains no digits.
    @inline(__always)
    static func optionalInt64FromBytes(_ bytes: ArraySlice<UInt8>) -> Int64? {
        guard !bytes.isEmpty, containsDigit(bytes) else { return nil }
        return int64FromBytes(bytes)
    }

    // MARK: - String Parsing

    /// Creates a String from ASCII bytes
    @inline(__always)
    static func stringFromBytes(_ bytes: ArraySlice<UInt8>) -> String {
        String(decoding: bytes, as: UTF8.self)
    }

    /// Parses an array of integers from comma-separated ASCII bytes
    static func parseIntArrayFromBytes(_ bytes: ArraySlice<UInt8>) -> [Int] {
        guard !bytes.isEmpty else { return [] }

        // Skip surrounding quotes if present
        var start = bytes.startIndex
        var end = bytes.endIndex

        if bytes[start] == asciiQuote {
            start += 1
        }
        if end > start && bytes[end - 1] == asciiQuote {
            end -= 1
        }

        guard start < end else { return [] }

        var results: [Int] = []
        var numStart = start
        var i = start

        while i < end {
            let byte = bytes[i]
            if byte == asciiComma {
                if i > numStart {
                    results.append(intFromBytes(bytes[numStart..<i]))
                }
                numStart = i + 1
                // Skip whitespace after comma
                while numStart < end && bytes[numStart] == asciiSpace {
                    numStart += 1
                }
                i = numStart
                continue
            }
            i += 1
        }

        // Last number
        if end > numStart {
            results.append(intFromBytes(bytes[numStart..<end]))
        }

        return results
    }
}
