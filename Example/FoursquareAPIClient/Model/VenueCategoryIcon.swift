//
//  VenueCategoryIcon.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct VenueCategoryIcon: Codable {
    let prefix: String
    let suffix: String

    var categoryIconUrl: String {
        return String(format: "%@%d%@", prefix, 88, suffix)
    }
}
