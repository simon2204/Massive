// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Fetch Treasury yield curve
    let yields = try await client.treasuryYields(TreasuryYieldsQuery())
    for yield in yields.results ?? [] {
        print("\(yield.date ?? ""): 2Y=\(yield.yield2Year ?? 0)% 10Y=\(yield.yield10Year ?? 0)%")
    }

    // Fetch inflation data (CPI, PCE)
    let inflation = try await client.inflation(InflationQuery())
    for obs in inflation.results ?? [] {
        print("\(obs.date ?? ""): CPI YoY=\(obs.cpiYearOverYear ?? 0)%")
    }

    // Fetch labor market data
    let labor = try await client.laborMarket(LaborMarketQuery())
    for obs in labor.results ?? [] {
        print("\(obs.date ?? ""): Unemployment=\(obs.unemploymentRate ?? 0)%")
    }

    // snippet.hide
}
