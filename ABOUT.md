# About Traveller

## Requirements
- Freestyle implementation of a travel web app taking advantage of an Expedia API, to search, filter and display deals, mostly Hotel deals, although some digging yields it is possible to fetch other offers of a different `productType`
- Design should account for hypothetical scalability (e.g. adding different product types, later blueprinted as `Offerable`)
- Implementation should be testable, extendable and performing.
- Frontend should be server-generated, and may require a simple templating library.
- Pipeline should encompass a CI build and test step with Travis.
- I will take this as a hackathon to experiment with new a language, framework and ways of doing things.


## Deadline
I had a short deadline, < 1 day, however I still wanted to write a POC with building blocks I find new, interesting and offer me a learning experience.

## Candidate Solutions
1. A quick implementation with NodeJS with Flow or Typescript type-safety and Express for routing.
2. Golang implementation with Gorilla HTTP packages
3. Swift 4.0 + Framework (IBM's Kitura, or Vapor)

## Winning Solution
It was candidate #3, Swift 4.0 with Vapor 2.0 framework (http://vapor.codes).

## Why Swift?
- Open-sourced language by Apple.
- Cross-platform, runs on Linux and MacOS.
- Compiled language, and hence offers high-performance.
- Type-safety, compile-time errors and warnings = less headache, better control.
- Swift offers Optionals, Generics and other great features that make a modern programming language.

## Motives
- I have been an avid follower of the (slow) progression of Swift into the server realm.
- I have been following the discussions on Swift Server Workgroup set up by the Swift team who are working on setting the future standard and defining the low-level APIs for upcoming, better server-side support (https://github.com/swift-server/work-group)
- Swift 4.0 brings interesting features, notably `Codable` (`Decodable` and `Encodable`) bringing native JSON mapping into Swift Foundation.
- Vapor is concurrent, offers Routing, View Rendering and Templating, enough for our requirements.

## Design & Implementation
### Models
Those are the business objects (Swift structs to be specific, passed by value and are thread-safe).
They map to the response object and offer native Swift types, such as Date, Int, and other children types by means of the new `Decodable` protocol.
### ExpediaService
Responsible for fetching the `OffersEnvelope` from the API, takes advantage of generics, and contains `offers`, an array of `Offerable`-conforming results, such as `HotelOffer`s.
ExpediaService is testable, it is designed for DI, by simple initialiazation with a client instance, allows for isolated unit testing of Expedia Service by passing a FakeResponder.

See: https://github.com/IbrahimZananiri/swifty-traveller/tree/master/Sources/App/ExpediaService

### Controller
`OfferController` Receives query parameters from a request and maps them to OfferRequest, which also carries OfferFilter.
The latter two types conform to a defined QueryStringable interface compatible with the Expedia API.

## Testability
Dependency Injection was used, e.g. initialize service with a Vapor HTTP Client or a `FakeResponder` that returns a fixed response, body from an included JSON file.

See Tests: 
https://github.com/IbrahimZananiri/swifty-traveller/tree/master/Tests/AppTests

### CI Pipeline
Travis builds and tests the project with hooks on `master` (https://travis-ci.org/IbrahimZananiri/swifty-traveller).

## Deployment methods used
1. Docker image, `Dockerfile` provided in repo.
2. Runs Locally, with XCode or just `swift build` & `swift run`.
3. Heroku-hosted.