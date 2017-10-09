import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

class RouteTests: TestCase {
    let drop = try! Droplet.testable()

    func testWelcome() throws {
        try drop
            .testResponse(to: .get, at: "/")
            .assertStatus(is: .ok)
            .assertBody(contains: "Welcome!")
    }
    
    func testOffers() throws {
        try drop
            .testResponse(to: .get, at: "/offers/hotels")
            .assertStatus(is: .ok)
            .assertBody(contains: "Hotel Offers")
    }

    func testInfo() throws {
        try drop
            .testResponse(to: .get, at: "info")
            .assertStatus(is: .ok)
            .assertBody(contains: "0.0.0.0")
    }
}

// MARK: Manifest

extension RouteTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testWelcome", testWelcome),
        ("testOffers", testOffers),
        ("testInfo", testInfo),
    ]
}
