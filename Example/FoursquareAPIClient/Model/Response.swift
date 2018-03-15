//
//  Response.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct Response <Response: Codable> : Codable {
    let response: Response
}
