//
//  OffersService.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/8/17.
//

import Foundation
import HTTP

public protocol HTTPRequestable {
    var httpRequest: HTTP.Request { get }
}

public struct OfferRequest<T> where T : Offerable {
    
    let filter: QueryStringable
    
    var httpRequest: HTTP.Request {
        let method = HTTP.Method.get
        let queryString: String = {
            var parts: [String] = [
                "scenario=deal-finder&page=foo&uid=foo",
                "productType=\(T.productType)",
            ]
            if let filterQueryString = filter.queryString {
                parts.append(filterQueryString)
            }
            return parts.joined(separator: "&")
        }()
        let uri = URI.init(scheme: "https", userInfo: nil, hostname: "offersvc.expedia.com", port: 443, path: "/offers/v2/getOffers", query: queryString, fragment: nil)
        return HTTP.Request(method: method, uri: uri)
    }
}

public class ExpediaService {
    
    private let client: ClientProtocol
    
    public init(client: ClientProtocol) {
        self.client = client
    }
    
    public enum OpError: Error {
        case nilBytes
    }
    
    public func getOffersEnvelope<T>(request: OfferRequest<T>) throws -> OffersEnvelope<T> {
        let response = try client.respond(to: request.httpRequest)
        guard let responseBodyBytes = response.body.bytes else {
            throw OpError.nilBytes
        }
        let responseBodyBytesData = Data(bytes: responseBodyBytes)
        let envelope = try JSONDecoder().decode(OffersEnvelope<T>.self, from: responseBodyBytesData)
        return envelope
    }
}


