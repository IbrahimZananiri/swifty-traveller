//
//  OffersService.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/8/17.
//

import Foundation
import HTTP

// ExpediaService for interacting with the Expedia API
// This service can handle mapping and is scalable for other Offerables

public class ExpediaService {
    
    // Vapor HTTP Client immutable property
    private let client: ClientProtocol
    
    // Initializer with a Vapor client
    public init(client: ClientProtocol) {
        self.client = client
    }
    
    // Possible operation errors enum
    public enum OpError: Error {
        // Thrown when bytes of Response are nil
        case nilBytes
    }
    
    // Fetch mapped OffersEnvelope by passing OfferRequest<T : Offerable> (which carries productType
    // and Filter instance)
    // Generic T is of Offerable type, e.g. HotelOffer, FlightOffer.
    // This method can throw.
    
    public func fetchOffersEnvelope<T>(request: OfferRequest<T>) throws -> OffersEnvelope<T> {
        // Ask the client to perform the request
        let response = try client.respond(to: request.httpRequest)
        guard let responseBodyBytes = response.body.bytes else {
            throw OpError.nilBytes
        }
        let responseBodyBytesData = Data(bytes: responseBodyBytes)
        // OffersEnvelope (and children properties) conform to Decodable protocol
        // and hence can be decoded. This is a Swift 4.0 feature.
        let envelope = try JSONDecoder().decode(OffersEnvelope<T>.self, from: responseBodyBytesData)
        return envelope
    }
}


