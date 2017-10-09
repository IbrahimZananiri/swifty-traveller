//
//  Models.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/8/17.
//

import Foundation

// Protocol/interface for Expedia's Offers, this at least covers product types Hotel and Flight
// This allows to cover other product types
// It also inhirits from the Decodable protocol
public protocol Offerable: Decodable {
    static var productType: String { get }
}

// HotelOffer type impelements Offerable protocol defines above
// It also implements Decodable allowing HotelOffer to be decode itself from an external representation (JSON)
public struct HotelOffer: Offerable, Decodable {
    public var offerDateRange: OfferDateRange
    public var destination: Destination
    public var hotelInfo: HotelInfo
    public var hotelPricingInfo: HotelPricingInfo
    // static immutable property assigning productType for HotelOffer-Offerable
    public static let productType = "Hotel"
}

public struct OfferDateRange: Decodable {
    public var lengthOfStay: Int
}

public struct OfferInfo: Decodable {
    public var currency: String
}

public struct Destination: Decodable {
    public var regionID: String
    public var longName: String
    public var shortName: String
    public var country: String
    public var city: String
}

public struct HotelInfo: Decodable {
    public var hotelId: String
    public var hotelName: String
    public var hotelImageUrl: String
    public var hotelStarRating: String // TODO: should find Decimal type
}

public struct HotelPricingInfo: Decodable {
    public var averagePriceValue: Double // Ideally Decimal
    public var originalPricePerNight: Double
}

// /getOffers service endpoint response root envelope
public struct OffersEnvelope<T> : Decodable where T : Offerable {
    
    fileprivate var offersMap: Dictionary<String, [T]> //[AnyHashable : Offerable]
    
    var productType: String {
        return T.productType
    }
    
    var offerInfo: OfferInfo
    
    var offers: [T]? {
        return self.offersMap[T.productType]
    }
    
    enum CodingKeys: String, CodingKey {
        case offers
        case offerInfo
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.offersMap = try values.decode(Dictionary<String, [T]>.self, forKey: .offers)
        self.offerInfo = try values.decode(OfferInfo.self, forKey: .offerInfo)
    }
}


// Conform type mappings to NodeRepresentable to support Leaf templating
// Not fun.
// TODO: Must find a better way to make Node from a Codable

extension OffersEnvelope: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("productType", self.productType)
        try node.set("offers", self.offers)
        try node.set("offerInfo", self.offerInfo)
        return node
    }
}

extension HotelOffer: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("offerDateRange", self.offerDateRange)
        try node.set("destination", self.destination)
        try node.set("hotelInfo", self.hotelInfo)
        try node.set("hotelPricingInfo", self.hotelPricingInfo)
        return node
    }
}

extension OfferInfo: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("currency", self.currency)
        return node
    }
}

extension OfferDateRange: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("lengthOfStay", self.lengthOfStay)
        return node
    }
}

extension Destination: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("city", self.city)
        try node.set("country", self.country)
        try node.set("shortName", self.shortName)
        try node.set("longName", self.longName)
        return node
    }
}

extension HotelInfo: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("hotelId", self.hotelId)
        try node.set("hotelName", self.hotelName)
        try node.set("hotelImageUrl", self.hotelImageUrl)
        try node.set("hotelStarRating", self.hotelStarRating)
        return node
    }
}

extension HotelPricingInfo: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("averagePriceValue", self.averagePriceValue)
        try node.set("originalPricePerNight", self.originalPricePerNight)
        return node
    }
}
