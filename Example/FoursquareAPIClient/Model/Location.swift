//
//  Location.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct Location: JSONDecodable {

    let address: String?
    let latitude: Double
    let longitude: Double

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let latitude = dictionary["lat"] as? Double else {
            throw JSONDecodeError.missingValue(key: "lat", actualValue: dictionary["lat"])
        }

        guard let longitude = dictionary["lng"] as? Double else {
            throw JSONDecodeError.missingValue(key: "lng", actualValue: dictionary["lng"])
        }

        self.address = dictionary["address"] as? String
        self.latitude = latitude
        self.longitude = longitude
    }
}
