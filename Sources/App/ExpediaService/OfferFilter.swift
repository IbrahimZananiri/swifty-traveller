//
//  Filter.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/8/17.
//

import Foundation
import Node

// Protocol/interface that defines a queryable type with URL Parameters
public protocol QueryStringable {
    // Should implement urlQuery getter calculated property
    // URLQueryItem is Swift Foundation name-value type for query parameters
    var queryString: String? { get }
}


// Offer Fitler definition with all optional properties
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

// OfferFilter conformance to QueryStringable protocol defined above
extension OfferFilter: QueryStringable {
    public var queryString: String? {
        // Building filter query string for expedia's service
        guard let node = try? self.makeNode(in: QueryStringContext()) else {
            return nil
        }
        // build query string, if errors were thrown in the process return nil
        return try? node.formURLEncoded().makeString()
    }
}


// OfferFilter confromance to NodeInitializable
// to initialize an OfferFilter from frontend query params Vapor's Node instance

extension OfferFilter: NodeInitializable, NodeRepresentable {
    
    public static let inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public static let expediaDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        // Turns out date format does not start with ":" as gist suggests
        // Commenting out dateFormat and replacing with "yyyy-MM-dd",
        // which makes it the same as inputDateFormatter.
        // formatter.dateFormat = ":yyyy-MM-dd"
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // Conform to NodeInitializable
    public init(node: Node) throws {
        
        self.destinationName = try node.get("destinationName")
        self.destinationCity = try node.get("destinationCity")
        
        // mapping input=date formatted to Foundation native Date
        let inputMinTripStartDate: String? = try node.get("minTripStartDate")
        if  let dateString = inputMinTripStartDate {
            self.minTripStartDate = OfferFilter.inputDateFormatter.date(from: dateString)
        }
        let inputMaxTripStartDate: String? = try node.get("maxTripStartDate")
        if  let dateString = inputMaxTripStartDate {
            self.maxTripStartDate = OfferFilter.inputDateFormatter.date(from: dateString)
        }
    }
    
    // Conform to NodeRepresentable
    public func makeNode(in context: Context?) throws -> Node {
        
        // From serialization context determine if
        // serializing to QueryStringContext type,
        // then use expedia's date formatter
        let dateFormatter: DateFormatter = (context?.isQueryStringContext ?? false) ?
            OfferFilter.expediaDateFormatter : OfferFilter.inputDateFormatter
        
        var node = Node(context)
        try node.set("destinationName", self.destinationName)
        if let date = self.minTripStartDate {
            try node.set("minTripStartDate", dateFormatter.string(from: date))
        }
        if let date = self.maxTripStartDate {
            try node.set("maxTripStartDate", dateFormatter.string(from: date))
        }
        return node
        
    }
    
}

final class QueryStringContext: Context {
}

extension Context {
    var isQueryStringContext: Bool {
        return self is QueryStringContext
    }
}

