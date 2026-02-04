/// The asset class for flat file data.
///
/// Each asset class represents a different market or data feed.
public enum AssetClass: String, Sendable, CaseIterable {
    /// US Stocks from the Securities Information Processor (SIP).
    ///
    /// Includes data from all major exchanges: NYSE, Nasdaq, Cboe, FINRA, and dark pools.
    case usStocks = "us_stocks_sip"

    /// US Options from the Options Price Reporting Authority (OPRA).
    case usOptions = "us_options_opra"

    /// Market indices (e.g., S&P 500, Dow Jones).
    case indices = "indices"

    /// Foreign exchange (currency pairs).
    case forex = "forex"

    /// Cryptocurrency markets.
    case crypto = "crypto"
}
