import XCTest
@testable import AppleSWIFT

final class AppleSWIFTTests: XCTestCase {
    private let framework = AppleSWIFT()

    func testValidPhoneNumberWithSpaces() {
        let result = framework.validateNumber("+33 6 12 34 56 78")
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.normalized, "+33612345678")
        XCTAssertEqual(result.masked, "+336******78")
    }

    func testInvalidPhoneNumberDoesNotLeakInput() {
        let result = framework.validateNumber("mot_de_passe_confidentiel")
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.normalized)
        XCTAssertEqual(result.masked, "***")
    }

    func testOversizedPhoneNumberIsRejectedSafely() {
        let oversized = String(repeating: "1", count: 100)
        let result = framework.validateNumber(oversized)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.masked, "***")
    }

    func testParseIPhoneModel() {
        let info = framework.parseModel("iPhone 14 Pro")
        XCTAssertTrue(info.isValid)
        XCTAssertEqual(info.brand, "iPhone")
        XCTAssertEqual(info.model, "14 Pro")
        XCTAssertEqual(info.formatted, "iPhone 14 Pro")
    }

    func testParseSamsungModelWithExtraSpaces() {
        let info = framework.parseModel("  Samsung   Galaxy   S21 ")
        XCTAssertTrue(info.isValid)
        XCTAssertEqual(info.brand, "Samsung")
        XCTAssertEqual(info.model, "Galaxy S21")
        XCTAssertEqual(framework.formatModel("  Samsung   Galaxy   S21 "), "Samsung Galaxy S21")
    }

    func testEmptyModelInput() {
        let info = framework.parseModel("   ")
        XCTAssertFalse(info.isValid)
        XCTAssertEqual(info.brand, "")
        XCTAssertEqual(info.model, "")
    }
}
