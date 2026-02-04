import Foundation
import Testing
@testable import Massive

@Suite("QueryBuilder")
struct QueryBuilderTests {

    @Test("Add string value")
    func addStringValue() {
        var builder = QueryBuilder()
        builder.add("key", "value")
        let items = builder.build()

        #expect(items?.count == 1)
        #expect(items?[0].name == "key")
        #expect(items?[0].value == "value")
    }

    @Test("Add nil string is ignored")
    func addNilString() {
        var builder = QueryBuilder()
        let nilString: String? = nil
        builder.add("key", nilString)
        let items = builder.build()

        #expect(items == nil)
    }

    @Test("Add integer value")
    func addIntegerValue() {
        var builder = QueryBuilder()
        builder.add("count", 42)
        let items = builder.build()

        #expect(items?.count == 1)
        #expect(items?[0].value == "42")
    }

    @Test("Add nil integer is ignored")
    func addNilInteger() {
        var builder = QueryBuilder()
        let nilInt: Int? = nil
        builder.add("count", nilInt)
        let items = builder.build()

        #expect(items == nil)
    }

    @Test("Add boolean true")
    func addBooleanTrue() {
        var builder = QueryBuilder()
        builder.add("enabled", true)
        let items = builder.build()

        #expect(items?[0].value == "true")
    }

    @Test("Add boolean false")
    func addBooleanFalse() {
        var builder = QueryBuilder()
        builder.add("enabled", false)
        let items = builder.build()

        #expect(items?[0].value == "false")
    }

    @Test("Add nil boolean is ignored")
    func addNilBoolean() {
        var builder = QueryBuilder()
        let nilBool: Bool? = nil
        builder.add("enabled", nilBool)
        let items = builder.build()

        #expect(items == nil)
    }

    @Test("Add SortOrder ascending")
    func addSortOrderAsc() {
        var builder = QueryBuilder()
        builder.add("sort", SortOrder.asc)
        let items = builder.build()

        #expect(items?[0].value == "asc")
    }

    @Test("Add SortOrder descending")
    func addSortOrderDesc() {
        var builder = QueryBuilder()
        builder.add("sort", SortOrder.desc)
        let items = builder.build()

        #expect(items?[0].value == "desc")
    }

    @Test("Add nil SortOrder is ignored")
    func addNilSortOrder() {
        var builder = QueryBuilder()
        let nilSort: Massive.SortOrder? = nil
        builder.add("sort", nilSort)
        let items = builder.build()

        #expect(items == nil)
    }

    @Test("Multiple values")
    func multipleValues() {
        var builder = QueryBuilder()
        builder.add("ticker", "AAPL")
        builder.add("limit", 100)
        builder.add("adjusted", true)
        builder.add("sort", Massive.SortOrder.asc)
        let items = builder.build()

        #expect(items?.count == 4)
    }

    @Test("Empty builder returns nil")
    func emptyBuilderReturnsNil() {
        let builder = QueryBuilder()
        let items = builder.build()

        #expect(items == nil)
    }

    @Test("Mixed nil and non-nil values")
    func mixedNilAndNonNil() {
        var builder = QueryBuilder()
        builder.add("ticker", "AAPL")
        builder.add("limit", nil as Int?)
        builder.add("adjusted", true)
        builder.add("sort", nil as Massive.SortOrder?)
        let items = builder.build()

        #expect(items?.count == 2)
        #expect(items?.contains { $0.name == "ticker" } == true)
        #expect(items?.contains { $0.name == "adjusted" } == true)
    }
}
