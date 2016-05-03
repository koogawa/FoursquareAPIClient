//
//  FoursquareAuthViewController.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/25.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import WebKit

@objc protocol FoursquareAuthViewControllerDelegate {
    func foursquareAuthViewControllerDidSucceed(accessToken: String)
    optional func foursquareAuthViewControllerDidFail(error: NSError)
}

class FoursquareAuthViewController: UIViewController {

    private let kFoursquareAuthUrlFormat = "https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@"

    var webview: WKWebView!
    var clientId: String
    var callback: String
    var delegate: FoursquareAuthViewControllerDelegate! = nil

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(clientId: String, callback: String) {
        self.clientId = clientId
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self,
            action: #selector(FoursquareAuthViewController.cancelButtonDidTap(_:)))
        navigationItem.leftBarButtonItem = cancelButton

        // WKWebView
        let rect : CGRect = UIScreen.mainScreen().bounds
        self.webview = WKWebView(frame: CGRectMake(0, 64, rect.size.width, rect.size.height - 64))
        self.webview.navigationDelegate = self
        self.view.addSubview(self.webview!)

        // Load auth url
        let authUrlString = NSString(format: kFoursquareAuthUrlFormat, clientId, callback)
        self.webview?.loadRequest(NSURLRequest(URL: NSURL(string: authUrlString as String)!))
    }

    override func viewDidDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    // MARK: - Private methods

    func cancelButtonDidTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - WKWebView delegate

extension FoursquareAuthViewController: WKNavigationDelegate {

    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        if let urlString = navigationAction.request.URL?.absoluteString
            where urlString.rangeOfString("access_token=") != nil {

            // Auth Success
            if let accessToken = urlString.componentsSeparatedByString("=").last {

                delegate?.foursquareAuthViewControllerDidSucceed(accessToken)

                dismissViewControllerAnimated(true, completion: nil)

                decisionHandler(WKNavigationActionPolicy.Cancel)
            }
        }

        decisionHandler(WKNavigationActionPolicy.Allow)
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        // Auth failed
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        delegate?.foursquareAuthViewControllerDidFail?(error)
    }
}
