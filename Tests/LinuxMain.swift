#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    // AppTests
    testCase(ExpediaServiceTests.allTests),
    testCase(RouteTests.allTests)
])

#endif
