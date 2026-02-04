// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Fetch income statements
    let income = try await client.incomeStatements(IncomeStatementsQuery(tickers: "AAPL"))
    for statement in income.results ?? [] {
        print("Revenue: \(statement.revenues?.value ?? 0)")
        print("Net Income: \(statement.netIncomeLoss?.value ?? 0)")
    }

    // Fetch balance sheets
    let balance = try await client.balanceSheets(BalanceSheetsQuery(tickers: "AAPL"))
    for sheet in balance.results ?? [] {
        print("Total Assets: \(sheet.assets?.value ?? 0)")
    }

    // Fetch financial ratios
    let ratios = try await client.ratios(RatiosQuery(ticker: "AAPL"))
    for ratio in ratios.results ?? [] {
        print("P/E Ratio: \(ratio.priceToEarnings ?? 0)")
        print("ROE: \(ratio.returnOnEquity ?? 0)")
    }

    // snippet.hide
}
