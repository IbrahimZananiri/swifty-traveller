@_exported import Vapor

import TLS


// Make a reusable client, better for performance and testability
fileprivate func makeClient(drop: Droplet) throws -> Responder {
    
    // Issue with OpenSSL may lead to closing SSL connection,
    // we'll create our own TLS context
    // TODO: Security should be revised before taking to real production
    let tlsContext = try TLS.Context.init(.client, .none, verifyHost: false, verifyCertificates: false, cipherSuite: nil)
    
    // Actually, recreate a new client when called.
    // to avoid detrimental issues.
    return try drop.client //.makeClient(hostname: "offersvc.expedia.com", port: 443, securityLayer: .tls(tlsContext))
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
