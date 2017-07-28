//
//  VenueCategoryIcon.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct VenueCategoryIcon: JSONDecodable {

    let prefix: String
    let suffix: String

    var categoryIconUrl: String {
        return String(format: "%@%d%@", prefix, 88, suffix)
    }


    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let prefix = dictionary["prefix"] as? String else {
            throw JSONDecodeError.missingValue(key: "prefix", actualValue: dictionary["prefix"])
        }

        guard let suffix = dictionary["suffix"] as? String else {
            throw JSONDecodeError.missingValue(key: "suffix", actualValue: dictionary["suffix"])
        }

        self.prefix = prefix
        self.suffix = suffix
    }
}
