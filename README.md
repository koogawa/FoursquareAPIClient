# FoursquareAPIClient

Very Simple Swift wrapper for Foursquare API v2

![Demo](./screen.png)

## Installation

Copy all the files from the FoursquareAPIClient folder to your project.

* FoursquareAPIClient.swift
* FoursquareAuthClient.swift (Optional)
* FoursquareAuthViewController.swift (Optional)

## Usage

### Setup session

```swift
let client = FoursquareAPIClient(accessToken: “YOUR_ACCESS_TOKEN”)
```
or

```swift
// Set v=YYYYMMDD param
let client = FoursquareAPIClient(accessToken: “YOUR_ACCESS_TOKEN”, version: "20140723")
```

### Search Venues

```swift
let parameter: [String: String] = [
    "ll": "35.702069,139.7753269",
    "limit": "10",
];

client.requestWithPath("venues/search", parameter: parameter) {
    (data, error) in

    // parse the JSON with NSJSONSerialization or Lib like SwiftyJson

    // result: {"meta":{"code":200},"notifications":[{"...
    println(NSString(data: data!, encoding: NSUTF8StringEncoding))
}
```

### Check in to Venue

```
let parameter: [String: String] = [
    "venueId": “55b731a9498eecdfbb3854a9”,
    "ll": "37.33262674912818,-122.030451055438",
    "alt": “10”,
];

client.requestWithPath("checkins/add", method: .POST, parameter: parameter) {
    [weak self] (data, error) in

    // parse the JSON with NSJSONSerialization or Lib like SwiftyJson

    // {"meta":{"code":200},"notifications":[{"type":"notificationTray”…
    var response = NSString(data: data!, encoding: NSUTF8StringEncoding)
}
```

## Authorization

### Setup

```
let client = FoursquareAuthClient(clientId: “YOUR_CLIENT_ID”,
	callback: “YOUR_CALLBACK_URL”,
	delegate: self)
client.authorizeWithRootViewController(self)
```

### Delegate

```
func foursquareAuthClientDidSucceed(accessToken: String) {
    tokenTextView.text = accessToken
}

func foursquareAuthClientDidFail(error: NSError) {
    tokenTextView.text = error.description
}
```


## Requirements

Swift 1.2 / iOS 8.0+

## License

The MIT License. See License.txt for details.

===========
[@koogawa](http://www.twitter.com/koogawa), July 2015.
