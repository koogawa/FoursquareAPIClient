//
//  Venue.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/21.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit

struct Venue: Codable {
    let venueId: String
    let name: String
    let location: Location
    let categories: [VenueCategory]?

    private enum CodingKeys: String, CodingKey {
        case venueId = "id"
        case name
        case location
        case categories
    }
}
