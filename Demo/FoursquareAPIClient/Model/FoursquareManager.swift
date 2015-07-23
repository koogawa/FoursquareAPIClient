//
//  FoursquareManager.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/21.
//  Copyright (c) 2015年 Kosuke Ogawa. All rights reserved.
//
//  ベニューオブジェクトを管理するシングルトンオブジェクト
//  ベニュー一覧を取得するときはこれを介して操作する

import UIKit
import MapKit

import SwiftyJSON

class FoursquareManager: NSObject {

    var venues = [Venue]()

    class func sharedManager() -> FoursquareManager {

        struct Static {
            static let instance = FoursquareManager()
        }
        return Static.instance
    }

    func searchVenuesWithCoordinate(coordinate: CLLocationCoordinate2D, query: String, completion: ((NSError?) -> ())?) {

        // TODO: この辺はちゃんと定数化しような
        let parameter: [String: String] = [
            "ll": "\(coordinate.latitude),\(coordinate.longitude)",
            "limit": SettingsManager.sharedManager().limitOfVenues().description,
            "oauth_token": "LZW1YQW5SVHEJP5JTHPWRS4MQ1MRMBVKM1B1FA2JO2YPFXHZ",
            "v": "20150710",
            "m": "swarm"
        ];

        FoursquareAPIClient.sharedClient().requestWithPath("venues/search", parameter: parameter) {
            [weak self] (data, error) in

            let json = JSON(data: data!)
            self?.venues = (self?.parseVenues(json["response"]["venues"]))!
            completion?(error)
        }
    }

    func parseVenues(venuesJSON: JSON) -> [Venue] {

        var venues = [Venue]()

        for (key: String, venueJSON: JSON) in venuesJSON {
            venues.append(Venue(json: venueJSON))
        }

        return venues
    }
}
