@_exported import Vapor

import TLS


// Make a reusable client, better for performance and testability
fileprivate func makeClient(drop: Droplet) throws -> Responder {
    
    // Actually, return drop's HTTP client.
    // to avoid a detrimental issue with SSL.
    return try drop.client
}

// Default production Expedia service
fileprivate func makeExpediaService(client: Responder) -> ExpediaService {
    return ExpediaService(client: client)
}


extension Droplet {
    
    func defaultExpediaService() throws -> ExpediaService {
        let client = try makeClient(drop: self)
        return makeExpediaService(client: client)
    }
    
    public func setup(service: ExpediaService? = nil) throws {
        let svc = try service ?? defaultExpediaService()
        let routes = Routes(view: view, service: svc)
        try collection(routes)
    }
}
