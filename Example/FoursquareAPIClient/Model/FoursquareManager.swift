//
//  FoursquareManager.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/21.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import MapKit

import SwiftyJSON

class FoursquareManager: NSObject {

    var accessToken: String!
    var venues = [Venue]()

    class func sharedManager() -> FoursquareManager {

        struct Static {
            static let instance = FoursquareManager()
        }
        return Static.instance
    }

    func searchVenuesWithCoordinate(coordinate: CLLocationCoordinate2D, completion: ((NSError?) -> ())?) {

        let client = FoursquareAPIClient(accessToken: accessToken)
        
        let parameter: [String: String] = [
            "ll": "\(coordinate.latitude),\(coordinate.longitude)",
        ];

        client.requestWithPath("venues/search", parameter: parameter) {
            [weak self] (data, error) in

            let json = JSON(data: data!)
            self?.venues = (self?.parseVenues(json["response"]["venues"]))!
            completion?(error)
        }
    }

    func checkinWithVenueId(venueId: String, location: CLLocation, completion: ((JSON, NSError?) -> ())?) {

        let client = FoursquareAPIClient(accessToken: accessToken)

        let parameter: [String: String] = [
            "venueId": venueId,
            "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "alt": "\(location.altitude)",
        ];

        client.requestWithPath("checkins/add", method: .POST, parameter: parameter) {
            (data, error) in

            let json = JSON(data: data!)
            completion?(json, error)
        }
    }

    func parseVenues(venuesJSON: JSON) -> [Venue] {

        var venues = [Venue]()

        for (key: _, venueJSON: JSON) in venuesJSON {
            venues.append(Venue(json: JSON))
        }

        return venues
    }
}
