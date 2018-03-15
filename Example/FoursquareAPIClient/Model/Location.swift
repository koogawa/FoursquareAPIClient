//
//  Location.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct Location: Codable {
    let address: String?
    let latitude: Double
    let longitude: Double

    private enum CodingKeys: String, CodingKey {
        case address
        case latitude = "lat"
        case longitude = "lng"
    }
}
