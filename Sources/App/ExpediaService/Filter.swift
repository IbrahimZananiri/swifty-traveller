//
//  Filter.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/8/17.
//

import Foundation

// Protocol/interface that defines a queryable type with URL Parameters
public protocol QueryStringable {
    // Should implement urlQuery getter calculated property
    // URLQueryItem is Swift Foundation name-value type for query parameters
    var queryString: String? { get }
}

public struct OfferFilter {
    var destinationName: String?
    var destinationCity: String?
    var regionId: Int?
    var minTripStartDate: Date?
    var maxTripStartDate: Date?
    var lengthOfStay: Int?
    var minStarRating: Int?
    var maxStarRating: Int?
    var minTotalRate: Int?
    var maxTotalRate: Int?
    var minGuestRating: Int?
}

extension OfferFilter: QueryStringable {
    public var queryString: String? {
        return ""
    }
}
