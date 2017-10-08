import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    let service: ExpediaService
    
    init(view: ViewRenderer, service: ExpediaService) {
        self.view = view
        self.service = service
    }

    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome")
        }

        /// GET /hello/...
        builder.resource("hello", HelloController(view))
        
        builder.resource("offers", OffersController(view: view, service: service) )

        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }

    }
}
