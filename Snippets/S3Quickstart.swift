// snippet.hide
import Massive

func example() async throws {
    // snippet.show

    let s3 = S3Client.massiveFlatFiles(credentials: S3Credentials(
        accessKeyId: "your-access-key",
        secretAccessKey: "your-secret-key"
    ))

    // Download and parse minute aggregates
    let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")

    for bar in bars.filter({ $0.ticker == "AAPL" }) {
        print("\(bar.windowStart): O=\(bar.open) C=\(bar.close) V=\(bar.volume)")
    }

    // Download and parse trades
    let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")

    // snippet.hide
}
