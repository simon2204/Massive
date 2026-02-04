import Foundation

extension MassiveClient {
    // MARK: - 10-K Sections

    /// Fetches full text content from 10-K SEC filing sections.
    ///
    /// Returns raw text from standardized sections like business description,
    /// risk factors, MD&A, and more.
    ///
    /// - Parameter query: The query parameters for filtering sections.
    /// - Returns: A response containing the section text content.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.tenKSections(TenKSectionsQuery(
    ///     ticker: "AAPL",
    ///     section: .business
    /// ))
    /// for section in response.results ?? [] {
    ///     print("Section: \(section.section ?? "")")
    ///     print("Text: \(section.text?.prefix(500) ?? "")")
    /// }
    /// ```
    public func tenKSections(_ query: TenKSectionsQuery = TenKSectionsQuery()) async throws -> TenKSectionsResponse {
        try await fetch(query)
    }

    // MARK: - Risk Factors

    /// Fetches categorized risk factors from SEC filings.
    ///
    /// Returns risk factors with AI-powered classification into primary,
    /// secondary, and tertiary categories.
    ///
    /// - Parameter query: The query parameters for filtering risk factors.
    /// - Returns: A response containing categorized risk factors.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.riskFactors(RiskFactorsQuery(ticker: "AAPL"))
    /// for risk in response.results ?? [] {
    ///     print("\(risk.primaryCategory ?? ""): \(risk.secondaryCategory ?? "")")
    ///     print("  \(risk.supportingText?.prefix(200) ?? "")")
    /// }
    /// ```
    public func riskFactors(_ query: RiskFactorsQuery = RiskFactorsQuery()) async throws -> RiskFactorsResponse {
        try await fetch(query)
    }

    // MARK: - Risk Categories

    /// Fetches the taxonomy of risk factor categories.
    ///
    /// Returns the classification system used to categorize risk factors,
    /// with descriptions for each category level.
    ///
    /// - Parameter query: The query parameters for filtering categories.
    /// - Returns: A response containing risk category definitions.
    /// - Throws: ``MassiveError`` if the request fails.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let response = try await client.riskCategories(RiskCategoriesQuery())
    /// for category in response.results ?? [] {
    ///     print("\(category.primaryCategory ?? "") > \(category.secondaryCategory ?? "")")
    ///     print("  \(category.description ?? "")")
    /// }
    /// ```
    public func riskCategories(_ query: RiskCategoriesQuery = RiskCategoriesQuery()) async throws -> RiskCategoriesResponse {
        try await fetch(query)
    }
}
