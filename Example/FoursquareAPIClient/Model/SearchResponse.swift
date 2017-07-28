//
//  SearchResponse.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct SearchResponse : JSONDecodable {
    let venues: [Venue]

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let venueObjects = dictionary["venues"] as? [Any] else {
            throw JSONDecodeError.missingValue(key: "venues", actualValue: dictionary["venues"])
        }

        let venues = try venueObjects.map {
            return try Venue(json: $0)
        }

        self.venues = venues
    }
}
