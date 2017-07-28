//
//  Checkin.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct Checkin: JSONDecodable {

    let checkinId: String
    let venue: Venue

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let checkinId = dictionary["id"] as? String else {
            throw JSONDecodeError.missingValue(key: "id", actualValue: dictionary["id"])
        }

        guard let venueObject = dictionary["venue"] else {
            throw JSONDecodeError.missingValue(key: "venue", actualValue: dictionary["venue"])
        }

        self.checkinId = checkinId
        self.venue = try Venue(json: venueObject)
    }
}
