import Foundation

/// Section identifiers for 10-K filings.
public enum TenKSection: String, Sendable, CaseIterable {
    case business
    case riskFactors = "risk_factors"
    case unresolved = "unresolved_staff_comments"
    case properties
    case legalProceedings = "legal_proceedings"
    case mineSafety = "mine_safety_disclosures"
    case marketForEquity = "market_for_registrants_common_equity"
    case selectedFinancialData = "selected_financial_data"
    case mda = "managements_discussion_and_analysis"
    case quantitativeDisclosures = "quantitative_and_qualitative_disclosures"
    case financialStatements = "financial_statements_and_supplementary_data"
    case changesInAccountants = "changes_in_and_disagreements_with_accountants"
    case controlsAndProcedures = "controls_and_procedures"
    case otherInformation = "other_information"
    case directors = "directors_executive_officers_and_corporate_governance"
    case executiveCompensation = "executive_compensation"
    case securityOwnership = "security_ownership_of_certain_beneficial_owners"
    case relationships = "certain_relationships_and_related_transactions"
    case accountingFees = "principal_accounting_fees_and_services"
    case exhibits = "exhibits_financial_statement_schedules"
    case formSummary = "form_10k_summary"
}
