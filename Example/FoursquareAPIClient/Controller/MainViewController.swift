//
//  MainViewController.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/23.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, FoursquareAuthClientDelegate {

    @IBOutlet weak var tokenTextView: UITextView!
    @IBOutlet weak var searchButton: UIButton!

    let clientId = "(YOUR_CLIENT_ID)"
    let callback = "(YOUR_CALLBACK_URL)"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Private methods

    @IBAction func didTapLoginButton(sender: AnyObject) {
        // Open auth view
        let client = FoursquareAuthClient(clientId: clientId, callback: callback, delegate: self)
        client.authorizeWithRootViewController(self)
    }


    // MARK: - FoursquareAuthClientDelegate

    func foursquareAuthClientDidSucceed(accessToken: String) {
        tokenTextView.text = accessToken
        searchButton.enabled = true
    }

    func foursquareAuthClientDidFail(error: NSError) {
        tokenTextView.text = error.description
        searchButton.enabled = false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowVenueList" {
            FoursquareManager.sharedManager().accessToken = tokenTextView.text
        }
    }

    @IBAction func didReturnToMainViewController(segue: UIStoryboardSegue) {

    }
}

