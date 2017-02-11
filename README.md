# FoursquareAPIClient

[![Build Status](https://www.bitrise.io/app/b220011d79899255.svg?token=Qq5QKCXCQgLZdEHECb1jOQ&branch=master)](https://www.bitrise.io/app/b220011d79899255) ![](https://img.shields.io/cocoapods/v/FoursquareAPIClient.svg?style=flat)

`FoursquareAPIClient` is very simple Swift networking library for Foursquare API v2.

![Demo](./screen.png)

## Installation

### From CocoaPods

First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'FoursquareAPIClient'
```

Second, install `FoursquareAPIClient` into your project:

```ruby
pod install
```

### Manually

Copy all the files from the FoursquareAPIClient folder to your project.

* FoursquareAPIClient.swift
* FoursquareAuthClient.swift (Optional)
* FoursquareAuthViewController.swift (Optional)

## Usage

### Import

```swift
import FoursquareAPIClient
```

### Setup session

```swift
let client = FoursquareAPIClient(accessToken: "YOUR_ACCESS_TOKEN")
```

or

```swift
let client = FoursquareAPIClient(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
```

#### Versioning

```swift
// Set v=YYYYMMDD param
let client = FoursquareAPIClient(accessToken: "YOUR_ACCESS_TOKEN", version: "20140723")
```

or

```swift
let client = FoursquareAPIClient(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET”,
                                  version: "20140723”)
```

### Search Venues

```swift
let parameter: [String: String] = [
    "ll": "35.702069,139.7753269",
    "limit": "10",
];

client.request(path: "venues/search", parameter: parameter) {
    [weak self] result in

    switch result {
        
    case let .success(data):
        // parse the JSON data with NSJSONSerialization or Lib like SwiftyJson
        let json = JSON(data: data) // e.g. {"meta":{"code":200},"notifications":[{"...

    case let .failure(error):
        // Error handling
        switch error {
        case let .connectionError(connectionError):
            print(connectionError)
        case let .apiError(apiError):
            print(apiError.errorType)   // e.g. endpoint_error
            print(apiError.errorDetail) // e.g. The requested path does not exist.
        }
    }
}
```

### Check in to Venue

```
let parameter: [String: String] = [
    "venueId": "55b731a9498eecdfb"3854a9”,
    "ll": "37.33262674912818,-122.030451055438",
    "alt": "10”,
];

client.request(path: "checkins/add", method: .post, parameter: parameter) {
    result in

    switch result {

    case let .success(data):
        // parse the JSON data with NSJSONSerialization or Lib like SwiftyJson
        let json = JSON(data: data) // e.g. {"meta":{"code":200},"notifications":[{"...

    case let .failure(error):
        // Error handling
        switch error {
        case let .connectionError(connectionError):
            print(connectionError)
        case let .apiError(apiError):
            print(apiError.errorType)   // e.g. endpoint_error
            print(apiError.errorDetail) // e.g. The requested path does not exist.
        }
    }
}
```

## Authorization

### Setup

```
let client = FoursquareAuthClient(clientId: "YOUR_CLIENT_ID",
                                  callback: "YOUR_CALLBACK_URL",
                                  delegate: self)
```

### Delegate

```
func foursquareAuthClientDidSucceed(accessToken: String) {
    print(accessToken)
}

func foursquareAuthClientDidFail(error: NSError) {
    print(error.description)
}
```


## Requirements

Swift 3.0 / iOS 8.0+

## Creator

[Kosuke Ogawa](http://www.twitter.com/koogawa)

## License

The MIT License. See License.txt for details.

