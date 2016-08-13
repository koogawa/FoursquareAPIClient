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

    var session: URLSession
    let accessToken: String?
    let clientId: String?
    let clientSecret: String?
    let version: String

    public init(accessToken: String, version: String = "20160813") {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = URLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: OperationQueue.main)
        self.accessToken = accessToken
        self.clientId = nil
        self.clientSecret = nil
        self.version = version
    }

    public init(clientId: String, clientSecret: String, version: String = "20160813") {

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = URLSession(configuration: configuration,
            delegate: nil,
            delegateQueue: OperationQueue.main)
        self.accessToken = nil
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.version = version
    }

    // FIXME: REMOVE _
    public func requestWithPath(_ path: String,
                                method: HTTPMethod = .GET,
                                parameter: [String: String],
                                completion: ((Data?,  NSError?) -> ())?) {
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
            request = NSMutableURLRequest(url: URL(string: urlString as String)!)
            request.httpMethod = method.rawValue
            request.httpBody = buildQueryString(fromDictionary: parameter).data(using: String.Encoding.utf8)
        }
        else {
            let urlString = kAPIBaseURLString + path + "?" + buildQueryString(fromDictionary: parameter)
            request = NSMutableURLRequest(url: URL(string: urlString as String)!)
            request.httpMethod = method.rawValue
        }

        let task = self.session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in

            // fixme: nil check?
            if (data == nil || error != nil) {
                completion?(nil, error)
                return
            }

            completion?(data, error)
        })
        
        task.resume()
    }

    private func buildQueryString(fromDictionary parameters: [String: String]) -> String {

        var urlVars = [String]()
        for (key, var val) in parameters {
            val = val.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            urlVars += [key + "=" + "\(val)"]
        }
        return urlVars.joined(separator: "&")
    }
}
