//
//  Venue.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/21.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit

struct Venue: JSONDecodable {

    let venueId: String
    let name: String
    let location: Location
    let categories: [VenueCategory]?

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let venueId = dictionary["id"] as? String else {
            throw JSONDecodeError.missingValue(key: "id", actualValue: dictionary["id"])
        }

        guard let name = dictionary["name"] as? String else {
            throw JSONDecodeError.missingValue(key: "name", actualValue: dictionary["name"])
        }

        guard let location = dictionary["location"] else {
            throw JSONDecodeError.missingValue(key: "location", actualValue: dictionary["location"])
        }

        guard let categoryObjects = dictionary["categories"] as? [Any] else {
            throw JSONDecodeError.missingValue(key: "categories", actualValue: dictionary["categories"])
        }

        let categories = try categoryObjects.map {
            return try VenueCategory(json: $0)
        }

        self.venueId = venueId
        self.name = name
        self.location = try Location(json: location)
        self.categories = categories
    }
}
