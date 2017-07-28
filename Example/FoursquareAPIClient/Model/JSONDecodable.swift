//
//  JSONDecodable.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

protocol JSONDecodable {
    init(json: Any) throws
}
