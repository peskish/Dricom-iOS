import XCTest
@testable import Dricom

class LicenseNormalizerTests: XCTestCase {
    func testLicenseNormalizing() {
        let normalizer = LicenseNormalizer.normalize
        let referenceLicense = "A245BC99"
        
        let licenseWithSpacesAndNewLines = " A24 5B C99\n"
        XCTAssertEqual(referenceLicense, normalizer(licenseWithSpacesAndNewLines))
        
        let licenseWithLowercase = "a245bC99"
        XCTAssertEqual(referenceLicense, normalizer(licenseWithLowercase))
        
        let licenseWithCyrillic = "А245вс99"
        XCTAssertEqual(referenceLicense, normalizer(licenseWithCyrillic))
    }
}
