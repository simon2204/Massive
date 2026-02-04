import Foundation

/// AWS-style credentials for S3 authentication.
///
/// Obtain your Access Key ID and Secret Access Key from the Massive dashboard.
///
/// ## Usage
///
/// ```swift
/// let credentials = S3Credentials(
///     accessKeyId: "AKIAIOSFODNN7EXAMPLE",
///     secretAccessKey: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
/// )
/// ```
public struct S3Credentials: Sendable {
    /// The AWS Access Key ID.
    public let accessKeyId: String

    /// The AWS Secret Access Key.
    public let secretAccessKey: String

    /// Creates new S3 credentials.
    ///
    /// - Parameters:
    ///   - accessKeyId: Your Access Key ID from the Massive dashboard.
    ///   - secretAccessKey: Your Secret Access Key from the Massive dashboard.
    public init(accessKeyId: String, secretAccessKey: String) {
        self.accessKeyId = accessKeyId
        self.secretAccessKey = secretAccessKey
    }
}
