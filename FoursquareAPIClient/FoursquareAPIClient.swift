//
//  FoursquareAPIClient.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/20.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

public class FoursquareAPIClient {

    private let kAPIBaseURLString = "https://api.foursquare.com/v2/"

    var session: NSURLSession
    let accessToken: String?
    let clientId: String?
    let clientSecret: String?
    let version: String

    public init(accessToken: String, version: String = "20150723") {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = NSURLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        self.accessToken = accessToken
        self.clientId = nil
        self.clientSecret = nil
        self.version = version
    }

    public init(clientId: String, clientSecret: String, version: String = "20150723") {

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = NSURLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        self.accessToken = nil
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.version = version
    }

    public func requestWithPath(path: String,
                                method: HTTPMethod = .GET,
                                parameter: [String: String],
                                completion: ((NSData?,  NSError?) -> ())?) {
        // Add necessary parameters
        var parameter = parameter
        if self.accessToken != nil {
            parameter["oauth_token"] = self.accessToken
        }
        else if self.clientId != nil && self.clientSecret != nil {
            parameter["client_id"] = self.clientId
            parameter["client_secret"] = self.clientSecret
        }
        parameter["v"] = self.version

        let request: NSMutableURLRequest

        if method == .POST {
            let urlString = kAPIBaseURLString + path
            request = NSMutableURLRequest(URL: NSURL(string: urlString as String)!)
            request.HTTPMethod = method.rawValue
            request.HTTPBody = buildQueryString(fromDictionary: parameter).dataUsingEncoding(NSUTF8StringEncoding)
        }
        else {
            let urlString = kAPIBaseURLString + path + "?" + buildQueryString(fromDictionary: parameter)
            request = NSMutableURLRequest(URL: NSURL(string: urlString as String)!)
            request.HTTPMethod = method.rawValue
        }

        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in

            if (data == nil || error != nil) {
                completion?(nil, error)
                return
            }

            completion?(data, error)
        }
        
        task.resume()
    }

    private func buildQueryString(fromDictionary parameters: [String: String]) -> String {

        var urlVars = [String]()
        for (key, var val) in parameters {
            val = val.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            urlVars += [key + "=" + "\(val)"]
        }
        return urlVars.joinWithSeparator("&")
    }
}
