//
//  OffersController.swift
//  travellerPackageDescription
//
//  Created by Ibrahim Z on 10/8/17.
//

import Vapor
import HTTP


final class OffersController: ResourceRepresentable {
    
    let view: ViewRenderer
    let service: ExpediaService
    
    // Main initializer, arguments take ViewRenderer and ExpediaService instance
    init(view: ViewRenderer, service: ExpediaService) {
        self.view = view
        self.service = service
    }
    
    // For future addition, URL key can be used to look up Offerable types, Hotel, Flight, Bundle?, etc
    let keyedTypeMapping: Dictionary<String, Offerable.Type> = [
        "hotels": HotelOffer.self,
        // Can add later:
        // "flights": FlightOffer.self,
    ]
    
    /// GET /offers
    func show(_ req: Request, _ productTypeKey: String) throws -> ResponseRepresentable {
        
        let filter = try OfferFilter(node: req.query)
        guard let _ = self.keyedTypeMapping[productTypeKey] else {
            throw Abort.notFound
        }
        // TODO: Use Offerable-conforming types instead of just HotelOffer
        let offerRequest = OfferRequest<HotelOffer>(filter: filter)
        let offersEnevelope: OffersEnvelope<HotelOffer> = try self.service.fetchOffersEnvelope(request: offerRequest)
        let hotelOffers: [HotelOffer] = offersEnevelope.offers ?? []
        return try view.make("offers", [
            "envelope": offersEnevelope,
            "offers": hotelOffers,
            "filter": filter,
        ], for: req)
    }
    
    // Make a Vapor Resource composed of the index action
    func makeResource() -> Resource<String> {
        return Resource(
            show: show
        )
    }
}

