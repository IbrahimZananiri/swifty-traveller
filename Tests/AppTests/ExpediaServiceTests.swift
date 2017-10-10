//
//  ServiceTests.swift
//  AppTests
//
//  Created by Ibrahim Z on 10/9/17.
//

import XCTest
import Foundation
import Testing
import HTTP
import Core
@testable import Vapor
@testable import App

// FakeResponder is a fake HTTP client type that will be passes to ExpediaService
// It reads from local json file, builds, and returns a known success Response
class FakeResponder: Responder {
    func respond(to request: Request) throws -> Response {
        let pwd = Core.workingDirectory()
        guard let data = FileManager.default.contents(atPath: "\(pwd)/Tests/AppTests/fake-response.json") else {
            throw ResponseError.bytesNotFound
        }
        return Response(status: .ok, body: data.makeBytes())
    }
    enum ResponseError: Error {
        case bytesNotFound
    }
}

class ExpediaServiceTests: TestCase {
    let drop = try! Droplet.testable()
    
    
    fileprivate var anOfferFilter: OfferFilter {
        let epoch = Date.init(timeIntervalSince1970: 0)
        let epochPlusOneDay = Date(timeIntervalSince1970: 24 * 60 * 60)
        let filter = OfferFilter(destinationName: "New York", destinationCity: nil, regionId: nil, minTripStartDate: epoch, maxTripStartDate: epochPlusOneDay, lengthOfStay: nil, minStarRating: nil, maxStarRating: nil, minTotalRate: nil, maxTotalRate: nil, minGuestRating: nil)
        return filter
    }
    
    func makeURLComponents(with query: String) -> URLComponents {
        let url = URL(string: "https://www.google.com?\(query)")!
        return URLComponents(url: url, resolvingAgainstBaseURL: false)!
    }
    
    func testOfferFilter() throws {
        let filter: OfferFilter = self.anOfferFilter
        let filterQueryString: String? = filter.queryString
        let expectedQueryString: String = "destinationName=New%20York&minTripStartDate=1970-01-01&maxTripStartDate=1970-01-02"
        XCTAssertNotNil(filterQueryString)
        
        let components: URLComponents = makeURLComponents(with: expectedQueryString)
        XCTAssertNotNil(components)
        
        let expectedComponents: URLComponents = makeURLComponents(with: filterQueryString!)
        XCTAssertEqual(components.queryItems!.sorted(by: {$0.name < $1.name}), expectedComponents.queryItems!.sorted(by: {$0.name < $1.name}))
    }
    
    func testOfferRequest() throws {
        let offerRequest = OfferRequest<HotelOffer>(filter: self.anOfferFilter)
        let uri: URI = offerRequest.httpRequest.uri
        XCTAssertEqual(uri.scheme, "https")
        XCTAssertEqual(uri.port, 443)
        XCTAssertEqual(uri.path, "/offers/v2/getOffers")
        XCTAssertNotNil(uri.query)
        
        let components: URLComponents = makeURLComponents(with: uri.query!)
        let expectedQueryString = "scenario=deal-finder&page=foo&uid=foo&productType=Hotel&destinationName=New%20York&minTripStartDate=1970-01-01&maxTripStartDate=1970-01-02"
        let expectedComponents: URLComponents = makeURLComponents(with: expectedQueryString)
        XCTAssertEqual(components.queryItems!.sorted(by: {$0.name < $1.name}), expectedComponents.queryItems!.sorted(by: {$0.name < $1.name}))
    }
    
    func testExpediaService() throws {
        // Initialize an ExpediaService with the fake client
        let svc: ExpediaService = ExpediaService(client: FakeResponder())
        let offerRequest = OfferRequest<HotelOffer>(filter: self.anOfferFilter)
        let envelope: OffersEnvelope<HotelOffer> = try svc.fetchOffersEnvelope(request: offerRequest)
        XCTAssertNotNil(envelope.offerInfo)
        XCTAssertEqual(envelope.offers?.count, 5)
    }

}

// MARK: Manifest

extension ExpediaServiceTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testOfferFilter", testOfferFilter),
        ("testOfferRequest", testOfferRequest),
        ("testExpediaService", testExpediaService),
        ]
}

