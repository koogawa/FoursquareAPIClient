//
//  FoursquareAPIClient.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/20.
//  Copyright (c) 2015年 Kosuke Ogawa. All rights reserved.
//
//  API とのネットワーク通信を抽象化。
//  リクエストを送信して、レスポンスの JSON を NSData にして返すところまでの責任を負う。

import UIKit

struct APIClientConstants {
    static let kAPIBaseURLString: String = "https://api.foursquare.com/v2/"
}

class FoursquareAPIClient: NSObject {

    let session: NSURLSession

    class func sharedClient() -> FoursquareAPIClient {

        struct Static {
            static let instance = FoursquareAPIClient()
        }
        return Static.instance
    }

    override init() {

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = [
            "Accept" : "application/json",
        ]
        self.session = NSURLSession(configuration: configuration)
        super.init()
    }

    func requestWithPath(path: String, parameter: [String: String], completion: ((NSData?,  NSError?) -> ())?) {

        let urlString = APIClientConstants.kAPIBaseURLString + path + buildQueryString(fromDictionary: parameter)
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
