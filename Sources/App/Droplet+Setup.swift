@_exported import Vapor

extension Droplet {
    public func setup() throws {
        let service = try ExpediaService(client: self.client.makeClient(hostname: "offersvc.expedia.com", port: 443, securityLayer: .tls(EngineClient.defaultTLSContext()), proxy: nil))
        let routes = Routes(view: view, service: service)
        try collection(routes)
    }
}
