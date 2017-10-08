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
//    var offerDateRange: OfferDateRange { get }
//    var destination: Destination { get }
    static var productType: String { get }
}

// HotelOffer type impelements Offerable protocol defines above
// It also implements Decodable allowing HotelOffer to be decode itself from an external representation (JSON)
public struct HotelOffer: Offerable, Decodable {
    public var offerDateRange: OfferDateRange
    public var destination: Destination
    public var hotelInfo: HotelInfo
    public static let productType = "Hotel"
}

public struct OfferDateRange: Decodable {
    public var lengthOfStay: Int
}

public struct Destination: Decodable {
    public var regionID: String
    public var longName: String
    public var shortName: String
    public var country: String
    public var province: String
    public var city: String
    public var tla: String
    public var nonLocalizedCity: String
}

public struct HotelInfo: Decodable {
    public var hotelId: String
    public var hotelName: String
    // TODO
}


// /getOffers service endpoint response root envelope
public struct OffersEnvelope<T> : Decodable where T : Offerable {
    
    var offers: Dictionary<String, [T]> //[AnyHashable : Offerable]
    
    func getOffers<T: Offerable>(productType: String) -> T? {
        return self.offers[productType] as? T
    }

    enum CodingKeys: String, CodingKey {
        case offers
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.offers = try values.decode(Dictionary<String, [T]>.self, forKey: .offers)
    }
}
