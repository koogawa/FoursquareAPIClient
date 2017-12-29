//
//  Checkin.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct Checkin: Codable {
    let checkinId: String
    let venue: Venue

    private enum CodingKeys: String, CodingKey {
        case checkinId = "id"
        case venue
    }
}
