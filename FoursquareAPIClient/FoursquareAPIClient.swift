//
//  FoursquareAPIClient.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/20.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit

class FoursquareAPIClient: NSObject {

    private let kAPIBaseURLString = "https://api.foursquare.com/v2/"

    let session: NSURLSession
    let accessToken: String
    let version: String

    init(accessToken: String, version: String = "20150723") {

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = NSURLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        self.accessToken = accessToken
        self.version = version
        super.init()
    }

    func requestWithPath(path: String, parameter: [String: String], completion: ((NSData?,  NSError?) -> ())?) {

        // Add necessary parameters
        var parameter = parameter
        parameter["oauth_token"] = self.accessToken
        parameter["v"] = self.version

        let urlString = kAPIBaseURLString + path + buildQueryString(fromDictionary: parameter)
        println(urlString)

        let request = NSURLRequest(URL: NSURL(string: urlString as String)!)
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in

            if (data == nil || error != nil) {
                completion?(nil, error)
                return
            }

            completion?(data, error)
        }
        task.resume()
    }

    func buildQueryString(fromDictionary parameters: [String: String]) -> String {

        var urlVars = [String]()
        for (key, var val) in parameters {
            val = val.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            urlVars += [key + "=" + "\(val)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
}
