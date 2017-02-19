import XCTest
@testable import Dricom

class RegistrationDataValidationServiceTests: XCTestCase {
    
    var validator: RegisterDataValidationServiceImpl!
    
    override func setUp() {
        super.setUp()
        
        validator = RegisterDataValidationServiceImpl()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPasswordValidation() {
        let validation = validator.validatePassword
        
        let shortPassword = "Gam12"
        XCTAssertNotNil(validation(shortPassword))
        
        let passwordWithoutDigits = "GamlaStan-"
        XCTAssertNotNil(validation(passwordWithoutDigits))
        
        let passwordWithoutUppercase = "asdfc1234"
        XCTAssertNotNil(validation(passwordWithoutUppercase))
        
        let passwordWithoutLowercase = "ASDFG1234"
        XCTAssertNotNil(validation(passwordWithoutLowercase))
        
        let passwordWithUppercaseLowercaseAndDigits = "Gfhjkm1"
        XCTAssertNil(validation(passwordWithUppercaseLowercaseAndDigits))
    }
}
