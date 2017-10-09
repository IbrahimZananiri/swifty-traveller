//
//  Request.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/9/17.
//

import Foundation
import HTTP

// Protocol / interface defining blueprint for any service Request,
// e.g. OfferRequest which conforms to this protocol
public protocol HTTPRequestable {
    var httpRequest: HTTP.Request { get }
}

// OfferRequest accepts generic Offerable to infer productType (e.g. Hotel, Flight, etc)
// It also carries Filter instance and builds HTTP.Request instance by conforming to HTTPRequestable protocol above.
// Instances of OfferRequest will be passed to ExpediaService fetching methods.
public struct OfferRequest<T> where T : Offerable {
    
    let filter: QueryStringable
    
    var httpRequest: HTTP.Request {
        
        // HTTP Method for getOffers is [GET]
        let method = HTTP.Method.get
        
        // Conformance to QueryStringable protocol
        // Implements queryString: String calculated property
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
        
        // URI instance with scheme, host, path, query string
        let uri = URI(scheme: "https", userInfo: nil, hostname: "offersvc.expedia.com", port: 443, path: "/offers/v2/getOffers", query: queryString, fragment: nil)
        
        // Return composed HTTP.Request instance
        return HTTP.Request(method: method, uri: uri)
    }
}
