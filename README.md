[![Build Status](https://travis-ci.org/IbrahimZananiri/swifty-traveller.svg?branch=master)](https://travis-ci.org/IbrahimZananiri/swifty-traveller)

## Overview
*Traveller* is a project I've built to demonstrate the capabilities of the Swift language on the server.
This solution interacts with an Expedia publicly-accessible API with live server-to-server calls and allows the user to search and filter Hotel offers.

## Building blocks
- Swift 4.0
- Vapor 2.0
- Leaf templating
- Travis CI

## Installation

### Docker
1. `git clone https://github.com/IbrahimZananiri/swifty-traveller`
2. `cd swifty-traveller`
3. `docker build -t traveller .`
4. `docker run --rm -ti -v $(pwd):/vapor -p 8080:8080 traveller swift run`

### Locally
1. Install Swift 4.0
2. `cd swifty-traveller`
3. `swift run` (or install Vapor and run `vapor build && vapor run`)

## Testing
Run `swift test`

## Demo
Visit:
https://swifty-traveller.herokuapp.com/offers/hotels
* Preferrably from a Chrome browser (for HTML5 date input field support)

## Thought Process
Outlined in ABOUT: 
https://github.com/IbrahimZananiri/swifty-traveller/blob/master/ABOUT.md