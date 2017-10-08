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
    
    init(view: ViewRenderer, service: ExpediaService) {
        self.view = view
        self.service = service
    }
    
    /// GET /offers
    func index(_ req: Request) throws -> ResponseRepresentable {
        let filter = OfferFilter()
        let offerRequest = OfferRequest<HotelOffer>(filter: filter)
        let r: OffersEnvelope<HotelOffer> = try self.service.getOffersEnvelope(request: offerRequest)
        print(r)
        return try view.make("hello", [
            "name": "World"
            ], for: req)
    }
    
    // Make a Resource composed of the index action
    func makeResource() -> Resource<String> {
        return Resource(
            index: index
        )
    }
}

