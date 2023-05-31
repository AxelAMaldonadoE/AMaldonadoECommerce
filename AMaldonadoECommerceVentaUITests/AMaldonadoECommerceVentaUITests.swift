//
//  AMaldonadoECommerceVentaUITests.swift
//  AMaldonadoECommerceVentaUITests
//
//  Created by MacBookMBA15 on 30/05/23.
//

import XCTest

final class AMaldonadoECommerceVentaUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Correo del Login
        let txtEmail = app.textFields["loginCorreo"]
        XCTAssertTrue(txtEmail.exists)
        txtEmail.tap()
        txtEmail.doubleTap()
        txtEmail.typeText("Esto es una prueba")
        
        
        let btnToRegister = app.buttons["Registrate ahora"]
        XCTAssertTrue(btnToRegister.exists)
        
        btnToRegister.tap()
        
        // Correo del Register
        let txtMail = app.textFields["registerCorreo"]
        XCTAssertTrue(txtMail.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
