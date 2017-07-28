//
//  Response.swift
//  FoursquareAPIClient
//
//  Created by ogawa_kousuke on 2017/07/27.
//  Copyright © 2017年 Kosuke Ogawa. All rights reserved.
//

import Foundation

struct Response <Response: JSONDecodable> : JSONDecodable {
    let response: Response

    init(json: Any) throws {
        guard let dictionary = json as? [String : Any] else {
            throw JSONDecodeError.invalidFormat(json: json)
        }

        guard let responseObject = dictionary["response"] else {
            throw JSONDecodeError.missingValue(key: "response", actualValue: dictionary["response"])
        }

        self.response = try Response(json: responseObject)
    }
}
