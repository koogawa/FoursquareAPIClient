//
//  FoursquareManager.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/21.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import MapKit

class FoursquareManager: NSObject {

    var accessToken: String!
    var venues: [Venue] = []

    class func sharedManager() -> FoursquareManager {

        struct Static {
            static let instance = FoursquareManager()
        }
        return Static.instance
    }

    func searchVenuesWithCoordinate(_ coordinate: CLLocationCoordinate2D, completion: ((Error?) -> ())?) {

        let client = FoursquareAPIClient(accessToken: accessToken)
        
        let parameter: [String: String] = [
            "ll": "\(coordinate.latitude),\(coordinate.longitude)",
        ];

        client.request(path: "venues/search", parameter: parameter) {
            [weak self] result in
            switch result {
            case let .success(data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Response<SearchResponse>.self, from: data)
                    self?.venues = response.response.venues
                    completion?(nil)
                } catch {
                    completion?(error)
                }
            case let .failure(error):
                completion?(error)
            }
        }
    }

    func checkinWithVenueId(_ venueId: String, location: CLLocation, completion: ((Checkin?, Error?) -> ())?) {

        let client = FoursquareAPIClient(accessToken: accessToken)

        let parameter: [String: String] = [
            "venueId": venueId,
            "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            "alt": "\(location.altitude)",
        ];

        client.request(path: "checkins/add", method: .post, parameter: parameter) {
            result in
            switch result {
            case let .success(data):
                let decoder: JSONDecoder = JSONDecoder()
                do {
                    let response = try decoder.decode(Response<CheckinResponse>.self, from: data)
                    completion?(response.response.checkin, nil)
                } catch {
                    completion?(nil, error)
                }
            case let .failure(error):
                completion?(nil, error)
            }
        }
    }
}
