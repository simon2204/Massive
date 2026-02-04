// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Fetch dividend history
    let dividends = try await client.dividends(DividendsQuery(ticker: "AAPL"))
    for dividend in dividends.results ?? [] {
        print("Ex-Date: \(dividend.exDividendDate ?? "") - $\(dividend.cashAmount ?? 0)")
    }

    // Fetch stock splits
    let splits = try await client.splits(SplitsQuery(ticker: "AAPL"))
    for split in splits.results ?? [] {
        print("\(split.executionDate ?? ""): \(split.splitFrom ?? 0)-for-\(split.splitTo ?? 0)")
    }

    // Fetch upcoming IPOs
    let ipos = try await client.ipos(IPOsQuery(ipoStatus: .pending))
    for ipo in ipos.results ?? [] {
        print("\(ipo.ticker ?? ""): \(ipo.issuerName ?? "") listing \(ipo.listingDate ?? "")")
    }

    // snippet.hide
}
