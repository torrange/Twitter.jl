# Twitter

[![Build Status](https://travis-ci.org/randyzwitch/Twitter.jl.png)](https://travis-ci.org/randyzwitch/Twitter.jl)

Twitter.jl is a Julia package to work with the Twitter API v1.1. Currently, only the REST API methods are supported; once [streaming capabilities are added to Requests.jl](https://github.com/loladiro/Requests.jl/issues/19), the Streaming API methods will be created as well.

##Twitter.jl API

Currently, all functions have required arguments for those parameters required by Twitter and an `options` keyword argument to provide a `Dict{String, String}` of optional parameters [Twitter API documentation](https://dev.twitter.com/docs/api/1.1). Most function calls will return either a Julia `Dict` or a typed Array. Bad requests will return the raw `Response` composite type from Requests.jl for debugging purposes.

DataFrame methods are defined for functions returning composite types: `TWEETS`, `PLACES`, `LISTS`, and `USERS`. Other DataFrame methods may be defined at a later date.

Note that the API is subject to change in the coming few versions, but should stablize shortly.

##Authentication

Authentication is accomplished by creating an application on [dev.twitter.com](https://dev.twitter.com). Once your application is setup, you can access your consumer_key, consumer_token, oauth_token and oauth_secret from the "Details" tab of the application.

```julia
Using Twitter

twitterauth("6nOtpXmf...", 
            "sES5Zlj096S...",
            "98689850-Hj...",
            "UroqCVpWKIt...")
```

This package does not currently support on-the-fly, pop-up a browser-type OAuth authentication. If this functionality is important to you (for example, if you wanted to write a Twitter GUI using Julia), it should be trivial to write the functions (please submit a pull request if you do so!)

##Code examples

See [tests.jl](https://github.com/randyzwitch/Twitter.jl/blob/master/tests/tests.jl) for example function calls. More detailed examples will be provided at a later date once API is finalized.

##Testing

Given the authenticated nature of the Twitter API, it's unlikely that testing will be built into Travis-CI. Rather, a test file will be provided in the future for testing, which will also serve as detailed examples.

##Licensing

Twitter.jl is licensed under the [MIT "Expat" license](https://github.com/randyzwitch/Twitter.jl/blob/master/LICENSE.md)

##TODO

General:
- Incorporate cursoring for methods returning many pages of results (MOST IMPORTANT TO SOLVE)
- Create Streaming API function calls
- Make code & interface more Julian, clean up any oddities

Nice to have (timeline uncertain):

- Clean up column types for DataFrame methods
- DataFrame methods for generic `Dict` responses
- Keyword arguments for returning DataFrame (to remove step in data retrieval process)
- Ability to save authentication keys to file, remove need for authentication each time
- Create Read The Docs documentation
- Create OAuth functions (not getting done until someone else submits a PR)
