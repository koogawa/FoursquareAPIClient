//
//  Venue.swift
//  VenueMap
//
//  Created by koogawa on 2015/07/21.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import SwiftyJSON_3_1_1

let kCategoryIconSize = 88  // pixel

struct Venue: CustomStringConvertible {

    let venueId: String?
    let name: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    var categoryIconURL: URL?

    var description: String {
        return "<venueId=\(venueId.debugDescription)"
            + ", name=\(name.debugDescription)"
            + ", address=\(address.debugDescription)"
            + ", latitude=\(latitude.debugDescription), longitude=\(longitude.debugDescription)"
            + ", categoryIconURL=\(categoryIconURL.debugDescription)>"
    }

    init(json: JSON) {

        self.venueId = json["id"].string
        self.name = json["name"].string
        self.address = json["location"]["address"].string
        self.latitude = json["location"]["lat"].double
        self.longitude = json["location"]["lng"].double
        self.categoryIconURL = nil

        // Primary Category
        if let categories = json["categories"].array {
            if !categories.isEmpty {
                let prefix = json["categories"][0]["icon"]["prefix"].string
                let suffix = json["categories"][0]["icon"]["suffix"].string
                let iconUrlString = String(format: "%@%d%@", prefix!, kCategoryIconSize, suffix!)
                self.categoryIconURL = URL(string: iconUrlString as String)
            }
        }
    }
}
