import Foundation
import Testing
@testable import Massive

@Suite("Common Types")
struct CommonTypesTests {

    // MARK: - Ticker

    @Test("Ticker from string literal")
    func tickerFromStringLiteral() {
        let ticker: Ticker = "AAPL"
        #expect(ticker.symbol == "AAPL")
    }

    @Test("Ticker equality")
    func tickerEquality() {
        let ticker1: Ticker = "AAPL"
        let ticker2 = Ticker("AAPL")
        #expect(ticker1 == ticker2)
    }

    @Test("Ticker different symbols not equal")
    func tickerDifferentSymbols() {
        let ticker1: Ticker = "AAPL"
        let ticker2: Ticker = "MSFT"
        #expect(ticker1 != ticker2)
    }

    @Test("Ticker hashable")
    func tickerHashable() {
        let ticker1: Ticker = "AAPL"
        let ticker2: Ticker = "AAPL"
        
        var set = Set<Ticker>()
        set.insert(ticker1)
        set.insert(ticker2)
        
        #expect(set.count == 1)
    }

    @Test("Ticker description")
    func tickerDescription() {
        let ticker: Ticker = "AAPL"
        #expect(ticker.description == "AAPL")
        #expect("\(ticker)" == "AAPL")
    }

    @Test("Ticker preserves case")
    func tickerPreservesCase() {
        let ticker = Ticker("aapl")
        #expect(ticker.symbol == "aapl")
    }

    // MARK: - SortOrder

    @Test("SortOrder raw values")
    func sortOrderRawValues() {
        #expect(SortOrder.asc.rawValue == "asc")
        #expect(SortOrder.desc.rawValue == "desc")
    }

    // MARK: - Sentiment

    @Test("Sentiment raw values")
    func sentimentRawValues() {
        #expect(Sentiment.positive.rawValue == "positive")
        #expect(Sentiment.negative.rawValue == "negative")
        #expect(Sentiment.neutral.rawValue == "neutral")
    }

    @Test("Sentiment all cases")
    func sentimentAllCases() {
        let allCases = Sentiment.allCases
        #expect(allCases.count == 4)
        #expect(allCases.contains(.positive))
        #expect(allCases.contains(.negative))
        #expect(allCases.contains(.neutral))
        #expect(allCases.contains(.unknown))
    }

    // MARK: - MassiveError

    @Test("MassiveError httpError with data")
    func massiveErrorHttpWithData() {
        let data = "Unauthorized".data(using: .utf8)!
        let error = MassiveError.httpError(statusCode: 401, data: data)

        if case .httpError(let code, let responseData) = error {
            #expect(code == 401)
            #expect(responseData == data)
        } else {
            #expect(Bool(false), "Expected httpError case")
        }
    }

    @Test("MassiveError httpError empty data")
    func massiveErrorHttpEmptyData() {
        let error = MassiveError.httpError(statusCode: 500, data: Data())

        if case .httpError(let code, let data) = error {
            #expect(code == 500)
            #expect(data.isEmpty)
        } else {
            #expect(Bool(false), "Expected httpError case")
        }
    }

    @Test("MassiveError invalidResponse")
    func massiveErrorInvalidResponse() {
        let error = MassiveError.invalidResponse

        if case .invalidResponse = error {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected invalidResponse case")
        }
    }

    // MARK: - Indicator Types

    @Test("IndicatorTimespan raw values")
    func indicatorTimespanRawValues() {
        #expect(IndicatorTimespan.minute.rawValue == "minute")
        #expect(IndicatorTimespan.hour.rawValue == "hour")
        #expect(IndicatorTimespan.day.rawValue == "day")
        #expect(IndicatorTimespan.week.rawValue == "week")
        #expect(IndicatorTimespan.month.rawValue == "month")
        #expect(IndicatorTimespan.quarter.rawValue == "quarter")
        #expect(IndicatorTimespan.year.rawValue == "year")
    }

    @Test("SeriesType raw values")
    func seriesTypeRawValues() {
        #expect(SeriesType.close.rawValue == "close")
        #expect(SeriesType.open.rawValue == "open")
        #expect(SeriesType.high.rawValue == "high")
        #expect(SeriesType.low.rawValue == "low")
    }

    // MARK: - Fundamentals Types

    @Test("FinancialTimeframe raw values")
    func financialTimeframeRawValues() {
        #expect(FinancialTimeframe.annual.rawValue == "annual")
        #expect(FinancialTimeframe.quarterly.rawValue == "quarterly")
        #expect(FinancialTimeframe.trailingTwelveMonths.rawValue == "trailing_twelve_months")
    }

    // MARK: - Corporate Actions Types

    @Test("DividendDistributionType raw values")
    func dividendDistributionTypeRawValues() {
        #expect(DividendDistributionType.recurring.rawValue == "recurring")
        #expect(DividendDistributionType.special.rawValue == "special")
        #expect(DividendDistributionType.supplemental.rawValue == "supplemental")
    }

    @Test("DividendFrequency raw values")
    func dividendFrequencyRawValues() {
        #expect(DividendFrequency.quarterly.rawValue == 4)
        #expect(DividendFrequency.annual.rawValue == 1)
        #expect(DividendFrequency.monthly.rawValue == 12)
    }

    // MARK: - Filings Types

    @Test("TenKSection raw values")
    func tenKSectionRawValues() {
        #expect(TenKSection.business.rawValue == "business")
        #expect(TenKSection.riskFactors.rawValue == "risk_factors")
        #expect(TenKSection.mda.rawValue == "managements_discussion_and_analysis")
    }

    @Test("TenKSection all cases")
    func tenKSectionAllCases() {
        let allCases = TenKSection.allCases
        #expect(allCases.count >= 3)
        #expect(allCases.contains(.business))
        #expect(allCases.contains(.riskFactors))
        #expect(allCases.contains(.mda))
    }
}
