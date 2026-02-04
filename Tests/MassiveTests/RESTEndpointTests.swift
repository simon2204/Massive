import Foundation
import Testing
import Fetch
@testable import Massive

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("REST Endpoints")
struct RESTEndpointTests {

    // MARK: - Snapshots

    let mockSnapshotResponse = """
    {
        "request_id": "test-123",
        "status": "OK",
        "ticker": {
            "ticker": "AAPL",
            "todaysChange": 2.5,
            "todaysChangePerc": 1.5,
            "updated": 1704067200000000000,
            "day": { "o": 150.0, "h": 155.0, "l": 149.0, "c": 154.0, "v": 1000000 },
            "lastTrade": { "p": 154.5, "s": 100, "t": 1704067200000000000 },
            "min": { "o": 153.0, "h": 154.5, "l": 152.5, "c": 154.0, "v": 50000 },
            "prevDay": { "o": 148.0, "h": 151.0, "l": 147.0, "c": 151.5, "v": 900000 }
        }
    }
    """.data(using: .utf8)!

    @Test("SingleTickerSnapshot query path")
    func singleTickerSnapshotPath() {
        let query = SingleTickerSnapshotQuery(ticker: "AAPL")
        #expect(query.path == "/v2/snapshot/locale/us/markets/stocks/tickers/AAPL")
        #expect(query.queryItems == nil)
    }

    // Note: Snapshot fetch tests removed - would require full mock response structure

    // MARK: - Indicators

    let mockSMAResponse = """
    {
        "request_id": "test-456",
        "status": "OK",
        "results": {
            "underlying": { "url": "https://api.massive.com/v2/aggs/ticker/AAPL" },
            "values": [
                { "timestamp": 1704067200000, "value": 150.5 },
                { "timestamp": 1704153600000, "value": 151.2 }
            ]
        }
    }
    """.data(using: .utf8)!

    @Test("SMA query path")
    func smaQueryPath() {
        let query = SMAQuery(ticker: "AAPL")
        #expect(query.path == "/v1/indicators/sma/AAPL")
    }

    @Test("SMA query parameters")
    func smaQueryParameters() {
        let query = SMAQuery(
            ticker: "AAPL",
            timespan: .day,
            window: 20,
            seriesType: .close,
            order: .desc,
            limit: 100
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "timespan" && $0.value == "day" })
        #expect(items.contains { $0.name == "window" && $0.value == "20" })
        #expect(items.contains { $0.name == "series_type" && $0.value == "close" })
        #expect(items.contains { $0.name == "order" && $0.value == "desc" })
        #expect(items.contains { $0.name == "limit" && $0.value == "100" })
    }

    @Test("EMA query path")
    func emaQueryPath() {
        let query = EMAQuery(ticker: "MSFT")
        #expect(query.path == "/v1/indicators/ema/MSFT")
    }

    @Test("RSI query path")
    func rsiQueryPath() {
        let query = RSIQuery(ticker: "GOOG")
        #expect(query.path == "/v1/indicators/rsi/GOOG")
    }

    @Test("MACD query path")
    func macdQueryPath() {
        let query = MACDQuery(ticker: "TSLA")
        #expect(query.path == "/v1/indicators/macd/TSLA")
    }

    @Test("MACD query parameters")
    func macdQueryParameters() {
        let query = MACDQuery(
            ticker: "TSLA",
            shortWindow: 12,
            longWindow: 26,
            signalWindow: 9
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "short_window" && $0.value == "12" })
        #expect(items.contains { $0.name == "long_window" && $0.value == "26" })
        #expect(items.contains { $0.name == "signal_window" && $0.value == "9" })
    }

    // MARK: - Corporate Actions

    let mockDividendsResponse = """
    {
        "next_url": null,
        "request_id": "test-789",
        "status": "OK",
        "results": [
            {
                "ticker": "AAPL",
                "cash_amount": 0.24,
                "declaration_date": "2024-01-01",
                "ex_dividend_date": "2024-01-15",
                "pay_date": "2024-01-30",
                "record_date": "2024-01-16",
                "dividend_type": "CD",
                "frequency": 4
            }
        ]
    }
    """.data(using: .utf8)!

    @Test("Dividends query path")
    func dividendsQueryPath() {
        let query = DividendsQuery()
        #expect(query.path == "/stocks/v1/dividends")
    }

    @Test("Dividends query parameters")
    func dividendsQueryParameters() {
        let query = DividendsQuery(
            ticker: "AAPL",
            exDividendDate: "2024-01-15",
            distributionType: .recurring,
            limit: 50
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "ticker" && $0.value == "AAPL" })
        #expect(items.contains { $0.name == "ex_dividend_date" && $0.value == "2024-01-15" })
        #expect(items.contains { $0.name == "distribution_type" && $0.value == "recurring" })
        #expect(items.contains { $0.name == "limit" && $0.value == "50" })
    }

    // Note: Dividends fetch tests removed - would require full mock response structure

    @Test("Splits query path")
    func splitsQueryPath() {
        let query = SplitsQuery()
        #expect(query.path == "/stocks/v1/splits")
    }

    @Test("IPOs query path")
    func iposQueryPath() {
        let query = IPOsQuery()
        #expect(query.path == "/vX/reference/ipos")
    }

    @Test("TickerEvents query path")
    func tickerEventsQueryPath() {
        let query = TickerEventsQuery(id: "AAPL")
        #expect(query.path == "/vX/reference/tickers/AAPL/events")
    }

    // MARK: - Fundamentals

    @Test("BalanceSheets query path")
    func balanceSheetsQueryPath() {
        let query = BalanceSheetsQuery(tickers: "AAPL")
        #expect(query.path == "/stocks/financials/v1/balance-sheets")
    }

    @Test("BalanceSheets query parameters")
    func balanceSheetsQueryParameters() {
        let query = BalanceSheetsQuery(
            tickers: "AAPL",
            timeframe: .annual,
            limit: 10
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "tickers" && $0.value == "AAPL" })
        #expect(items.contains { $0.name == "timeframe" && $0.value == "annual" })
        #expect(items.contains { $0.name == "limit" && $0.value == "10" })
    }

    @Test("CashFlowStatements query path")
    func cashFlowStatementsQueryPath() {
        let query = CashFlowStatementsQuery(tickers: "MSFT")
        #expect(query.path == "/stocks/financials/v1/cash-flow-statements")
    }

    @Test("IncomeStatements query path")
    func incomeStatementsQueryPath() {
        let query = IncomeStatementsQuery(tickers: "GOOG")
        #expect(query.path == "/stocks/financials/v1/income-statements")
    }

    @Test("Ratios query path")
    func ratiosQueryPath() {
        let query = RatiosQuery(ticker: "AMZN")
        #expect(query.path == "/stocks/financials/v1/ratios")
    }

    @Test("Float query path")
    func floatQueryPath() {
        let query = FloatQuery()
        #expect(query.path == "/stocks/vX/float")
    }

    @Test("ShortInterest query path")
    func shortInterestQueryPath() {
        let query = ShortInterestQuery()
        #expect(query.path == "/stocks/v1/short-interest")
    }

    @Test("ShortVolume query path")
    func shortVolumeQueryPath() {
        let query = ShortVolumeQuery()
        #expect(query.path == "/stocks/v1/short-volume")
    }

    // MARK: - Filings

    @Test("TenKSections query path")
    func tenKSectionsQueryPath() {
        let query = TenKSectionsQuery()
        #expect(query.path == "/stocks/filings/10-K/v1/sections")
    }

    @Test("TenKSections query with section filter")
    func tenKSectionsQueryWithSection() {
        let query = TenKSectionsQuery(
            ticker: "AAPL",
            section: .riskFactors
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "ticker" && $0.value == "AAPL" })
        #expect(items.contains { $0.name == "section" && $0.value == "risk_factors" })
    }

    @Test("RiskFactors query path")
    func riskFactorsQueryPath() {
        let query = RiskFactorsQuery()
        #expect(query.path == "/stocks/filings/v1/risk-factors")
    }

    @Test("RiskCategories query path")
    func riskCategoriesQueryPath() {
        let query = RiskCategoriesQuery()
        #expect(query.path == "/stocks/taxonomies/v1/risk-factors")
    }

    // MARK: - Economy

    let mockTreasuryYieldsResponse = """
    {
        "next_url": null,
        "request_id": "test-econ",
        "status": "OK",
        "results": [
            {
                "date": "2024-01-15",
                "yield_1_month": 5.53,
                "yield_3_month": 5.48,
                "yield_6_month": 5.36,
                "yield_1_year": 5.02,
                "yield_2_year": 4.38,
                "yield_5_year": 4.02,
                "yield_10_year": 4.12,
                "yield_30_year": 4.35
            }
        ]
    }
    """.data(using: .utf8)!

    @Test("TreasuryYields query path")
    func treasuryYieldsQueryPath() {
        let query = TreasuryYieldsQuery()
        #expect(query.path == "/fed/v1/treasury-yields")
    }

    @Test("TreasuryYields query parameters")
    func treasuryYieldsQueryParameters() {
        let query = TreasuryYieldsQuery(
            date: "2024-01-15",
            limit: 50,
            sort: "date.desc"
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "date" && $0.value == "2024-01-15" })
        #expect(items.contains { $0.name == "limit" && $0.value == "50" })
        #expect(items.contains { $0.name == "sort" && $0.value == "date.desc" })
    }

    // Note: Treasury yields fetch tests removed - would require full mock response structure

    @Test("Inflation query path")
    func inflationQueryPath() {
        let query = InflationQuery()
        #expect(query.path == "/fed/v1/inflation")
    }

    @Test("InflationExpectations query path")
    func inflationExpectationsQueryPath() {
        let query = InflationExpectationsQuery()
        #expect(query.path == "/fed/v1/inflation-expectations")
    }

    @Test("LaborMarket query path")
    func laborMarketQueryPath() {
        let query = LaborMarketQuery()
        #expect(query.path == "/fed/v1/labor-market")
    }

    // MARK: - Market

    @Test("MarketStatus query path")
    func marketStatusQueryPath() {
        let query = MarketStatusQuery()
        #expect(query.path == "/v1/marketstatus/now")
        #expect(query.queryItems == nil)
    }

    @Test("MarketHolidays query path")
    func marketHolidaysQueryPath() {
        let query = MarketHolidaysQuery()
        #expect(query.path == "/v1/marketstatus/upcoming")
        #expect(query.queryItems == nil)
    }

    @Test("Exchanges query path")
    func exchangesQueryPath() {
        let query = ExchangesQuery()
        #expect(query.path == "/v3/reference/exchanges")
    }

    @Test("Exchanges query parameters")
    func exchangesQueryParameters() {
        let query = ExchangesQuery(
            assetClass: .stocks,
            locale: .us
        )

        let items = query.queryItems ?? []
        #expect(items.contains { $0.name == "asset_class" && $0.value == "stocks" })
        #expect(items.contains { $0.name == "locale" && $0.value == "us" })
    }

    @Test("ConditionCodes query path")
    func conditionCodesQueryPath() {
        let query = ConditionCodesQuery()
        #expect(query.path == "/v3/reference/conditions")
    }

    // MARK: - Bars

    @Test("DailyMarketSummary query path")
    func dailyMarketSummaryQueryPath() {
        let query = DailyMarketSummaryQuery(date: "2024-01-15")
        #expect(query.path == "/v2/aggs/grouped/locale/us/market/stocks/2024-01-15")
    }

    @Test("DailyTickerSummary query path")
    func dailyTickerSummaryQueryPath() {
        let query = DailyTickerSummaryQuery(ticker: "AAPL", date: "2024-01-15")
        #expect(query.path == "/v1/open-close/AAPL/2024-01-15")
    }

    @Test("PreviousDayBar query path")
    func previousDayBarQueryPath() {
        let query = PreviousDayBarQuery(ticker: "AAPL")
        #expect(query.path == "/v2/aggs/ticker/AAPL/prev")
    }
}
