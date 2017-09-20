//
//  VenueCategory.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct VenueCategory: Codable {
    let categoryId: String
    let name: String
    let icon: VenueCategoryIcon

    private enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case name
        case icon
    }
}
