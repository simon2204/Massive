import Foundation
import Massive

@main
struct Demo {
    static func main() async {
        let apiKey = ProcessInfo.processInfo.environment["MASSIVE_API_KEY"] ?? ""

        guard !apiKey.isEmpty else {
            print("Error: MASSIVE_API_KEY not set")
            print("Set via: export MASSIVE_API_KEY=your_key")
            return
        }

        let client = MassiveClient(apiKey: apiKey)

        print("MassiveClient Demo")
        print(String(repeating: "-", count: 40))

        await demoNews(client)
        await demoBars(client)

        print(String(repeating: "-", count: 40))
        print("Done")
    }

    static func demoNews(_ client: MassiveClient) async {
        print("\n[News] Fetching articles for AAPL...")

        do {
            let news = try await client.news(NewsQuery(ticker: "AAPL", limit: 3))
            print("Found \(news.count) articles:\n")

            for article in news.results.prefix(3) {
                print("  \(article.title)")
                if let sentiment = article.insights?.first?.sentiment {
                    print("  Sentiment: \(sentiment)")
                }
                print()
            }
        } catch {
            print("Error: \(error)")
        }
    }

    static func demoBars(_ client: MassiveClient) async {
        print("\n[Bars] Fetching daily bars for AAPL...")

        do {
            let bars = try await client.bars(BarsQuery(
                ticker: "AAPL",
                from: "2024-01-01",
                to: "2024-01-10"
            ))
            print("Found \(bars.resultsCount) bars:\n")

            for bar in bars.results?.prefix(5) ?? [] {
                let date = Date(timeIntervalSince1970: Double(bar.t) / 1000)
                let dateStr = date.formatted(date: .abbreviated, time: .omitted)
                print("  \(dateStr): O=\(bar.o) H=\(bar.h) L=\(bar.l) C=\(bar.c)")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
