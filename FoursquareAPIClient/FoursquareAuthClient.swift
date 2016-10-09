//
//  FoursquareAuthClient.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/27.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import Foundation

@objc public protocol FoursquareAuthClientDelegate {
    func foursquareAuthClientDidSucceed(accessToken: String)
    optional func foursquareAuthClientDidFail(error: NSError)
}

public class FoursquareAuthClient: NSObject {

    var clientId: String
    var callback: String
    var delegate: FoursquareAuthClientDelegate

    public init(clientId: String, callback: String, delegate: FoursquareAuthClientDelegate) {
        self.clientId = clientId
        self.callback = callback
        self.delegate = delegate
    }

    public func authorizeWithRootViewController(controller: UIViewController) {
        let viewController = FoursquareAuthViewController(clientId: clientId, callback: callback)
        viewController.delegate = self
        let naviController = UINavigationController(rootViewController: viewController)
        controller.presentViewController(naviController, animated: true, completion: nil)
    }
}

// MARK: - FoursquareAuthViewControllerDelegate

extension FoursquareAuthClient: FoursquareAuthViewControllerDelegate {

    func foursquareAuthViewControllerDidSucceed(accessToken: String) {
        delegate.foursquareAuthClientDidSucceed(accessToken)
    }

    func foursquareAuthViewControllerDidFail(error: NSError) {
        delegate.foursquareAuthClientDidFail?(error)
    }
}
