//
//  FoursquareAuthClient.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/27.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit

@objc public protocol FoursquareAuthClientDelegate {
    func foursquareAuthClientDidSucceed(accessToken: String)
    @objc optional func foursquareAuthClientDidFail(error: Error)
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

    public func authorizeWithRootViewController(_ controller: UIViewController) {
        let viewController = FoursquareAuthViewController(clientId: clientId, callback: callback)
        viewController.delegate = self
        let naviController = UINavigationController(rootViewController: viewController)
        controller.present(naviController, animated: true, completion: nil)
    }
}

// MARK: - FoursquareAuthViewControllerDelegate

extension FoursquareAuthClient: FoursquareAuthViewControllerDelegate {

    func foursquareAuthViewControllerDidSucceed(accessToken: String) {
        delegate.foursquareAuthClientDidSucceed(accessToken: accessToken)
    }

    func foursquareAuthViewControllerDidFail(error: Error) {
        delegate.foursquareAuthClientDidFail?(error: error)
    }
}
