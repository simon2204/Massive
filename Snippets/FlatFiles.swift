// snippet.hide
import Massive
import Foundation

func example() async throws {
    // snippet.show

    // Create S3 client with your credentials
    let credentials = S3Credentials(
        accessKeyId: "your-access-key",
        secretAccessKey: "your-secret-key"
    )
    let s3 = S3Client.massiveFlatFiles(credentials: credentials)

    // Download and parse minute bars for a specific date
    let bars = try await s3.minuteAggregates(for: .usStocks, date: "2025-01-15")
    for bar in bars.prefix(10) {
        print("\(bar.ticker): O=\(bar.open) H=\(bar.high) L=\(bar.low) C=\(bar.close)")
    }

    // Download and parse trades
    let trades = try await s3.trades(for: .usStocks, date: "2025-01-15")
    print("Total trades: \(trades.count)")

    // List available files
    let files = try await s3.listFlatFiles(
        assetClass: .usStocks,
        dataType: .minuteAggregates,
        year: 2025,
        month: 1
    )
    for file in files.objects {
        print(file.key)
    }

    // snippet.hide
}
