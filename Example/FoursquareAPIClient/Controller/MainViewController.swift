//
//  MainViewController.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/23.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import SafariServices

@available(iOS 11.0, *)
class MainViewController: UIViewController, FoursquareAuthClientDelegate {

    @IBOutlet weak var tokenTextView: UITextView!
    @IBOutlet weak var searchButton: UIButton!

    private var session: SFAuthenticationSession? = nil

    private let foursquareAuthUrlFormat = "https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@"
    private let clientId = ""
    private let callback = "fsoauthexample://authorized"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Private methods

    @IBAction func didTapLoginButton(_ sender: AnyObject) {
        // Open auth view
        
        // Encode URL
        let authURLString = String(format: foursquareAuthUrlFormat, self.clientId, self.callback)
        guard let encodedURLString = authURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("Invalid URL: ", authURLString)
            return
        }

        guard let authURL = URL(string: encodedURLString) else {
            print("Invalid URL: ", authURLString)
            return
        }

        guard let callbackURLScheme = URL(string: self.callback) else {
            print("Invalid callbackURLScheme: ", self.callback)
            return
        }

        self.session = SFAuthenticationSession(url: authURL, callbackURLScheme: callbackURLScheme.scheme) { url, error in
            print(url, error)
            // fsoauthexample://authorized#access_token=XXXXXXXXXXXXXX
            if let urlString = navigationAction.request.url?.absoluteString,
                urlString.range(of: "access_token=") != nil {

                // Auth Success
                if let accessToken = urlString.components(separatedBy: "=").last {
                    delegate?.foursquareAuthViewControllerDidSucceed(accessToken: accessToken)
                    dismiss(animated: true, completion: nil)
                    decisionHandler(WKNavigationActionPolicy.cancel)
                    return
                }
            }

        }
        session?.start()
return

        let client = FoursquareAuthClient(clientId: clientId, callback: callback, delegate: self)
        client.authorizeWithRootViewController(self)
    }


    // MARK: - FoursquareAuthClientDelegate

    func foursquareAuthClientDidSucceed(accessToken: String) {
        tokenTextView.text = accessToken
        searchButton.isEnabled = true
    }

    func foursquareAuthClientDidFail(error: Error) {
        tokenTextView.text = error.localizedDescription
        searchButton.isEnabled = false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowVenueList" {
            FoursquareManager.sharedManager().accessToken = tokenTextView.text
        }
    }

    @IBAction func didReturnToMainViewController(_ segue: UIStoryboardSegue) {

    }
}

