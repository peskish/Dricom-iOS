import XCTest
@testable import Dricom

class LicensePartsTests: XCTestCase {
    func testLicensePartsCreationFromString() {
        let shortNumberString = "A123BC"
        XCTAssertNil(LicenseParts(licenseNumber: shortNumberString))
        
        let correctLicense = "A123BC99"
        guard let licenseParts = LicenseParts(licenseNumber: correctLicense) else {
            XCTFail("LicenseParts was expected but wasn't created")
            return
        }
        
        XCTAssertEqual(licenseParts.countryCode, "RUS")
        XCTAssertEqual(licenseParts.firstLetter, "A ")
        XCTAssertEqual(licenseParts.numberPart, "123")
        XCTAssertEqual(licenseParts.restLetters, " BC")
        XCTAssertEqual(licenseParts.regionCode, "99")
    }
}
