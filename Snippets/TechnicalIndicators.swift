// snippet.hide
import Massive

func example() async throws {
    let apiKey = "your-api-key"
    // snippet.show

    let client = MassiveClient(apiKey: apiKey)

    // Fetch Simple Moving Average (SMA)
    let sma = try await client.sma(SMAQuery(
        ticker: "AAPL",
        timespan: .day,
        window: 20,
        seriesType: .close
    ))

    // Fetch Relative Strength Index (RSI)
    let rsi = try await client.rsi(RSIQuery(
        ticker: "AAPL",
        timespan: .day,
        window: 14
    ))

    // Fetch MACD
    let macd = try await client.macd(MACDQuery(
        ticker: "AAPL",
        timespan: .day,
        shortWindow: 12,
        longWindow: 26,
        signalWindow: 9
    ))

    // snippet.hide
}
