//
//  VenueCategory.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct VenueCategory: JSONDecodable {

    let categoryId: String
    let name: String
    let icon: VenueCategoryIcon

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let categoryId = dictionary["id"] as? String else {
            throw JSONDecodeError.missingValue(key: "id", actualValue: dictionary["id"])
        }

        guard let name = dictionary["name"] as? String else {
            throw JSONDecodeError.missingValue(key: "name", actualValue: dictionary["name"])
        }

        guard let iconObject = dictionary["icon"] else {
            throw JSONDecodeError.missingValue(key: "icon", actualValue: dictionary["icon"])
        }

        self.categoryId = categoryId
        self.name = name
        self.icon = try VenueCategoryIcon(json: iconObject)
    }
}
