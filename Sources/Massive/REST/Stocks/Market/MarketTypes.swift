import Foundation

/// Asset class for filtering market data.
public enum MarketAssetClass: String, Sendable, CaseIterable {
    case stocks
    case options
    case crypto
    case fx
    case futures
}

/// Locale for filtering market data.
public enum MarketLocale: String, Sendable, CaseIterable {
    case us
    case global
}

/// Exchange type classification.
public enum ExchangeType: String, Codable, Sendable {
    case exchange
    case TRF
    case SIP
}

/// Data type for condition codes.
public enum ConditionDataType: String, Sendable, CaseIterable {
    case trade
    case bbo
    case nbbo
}

/// SIP (Securities Information Processor) type.
public enum SIPType: String, Sendable, CaseIterable {
    case CTA
    case UTP
    case OPRA
}

/// Condition type classification.
public enum ConditionType: String, Codable, Sendable {
    case saleCondition = "sale_condition"
    case quoteCondition = "quote_condition"
    case sipGeneratedFlag = "sip_generated_flag"
    case financialStatusIndicator = "financial_status_indicator"
    case shortSaleRestrictionIndicator = "short_sale_restriction_indicator"
    case settlementCondition = "settlement_condition"
    case marketCondition = "market_condition"
    case tradeThruExempt = "trade_thru_exempt"
}
