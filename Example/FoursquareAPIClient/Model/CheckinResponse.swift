//
//  CheckinResponse.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct CheckinResponse : JSONDecodable {
    let checkin: Checkin

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let checkinObjects = dictionary["checkin"] else {
            throw JSONDecodeError.missingValue(key: "checkin", actualValue: dictionary["checkin"])
        }

        self.checkin = try Checkin(json: checkinObjects)
    }
}
