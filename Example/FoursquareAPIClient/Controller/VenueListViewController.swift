//
//  VenueListViewController.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/23.
//  Copyright (c) 2015 Kosuke Ogawa. All rights reserved.
//

import UIKit
import MapKit

class VenueListViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var isLocationInitialized = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        locationManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Private methods

    func fetchVenues(_ coordinate: CLLocationCoordinate2D) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        FoursquareManager.sharedManager().searchVenuesWithCoordinate(coordinate, completion: {
            [weak self] (error) in

            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            self?.tableView.reloadData()
        })
    }


    // MARK: - CLLocationManager delegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                return
        }

        self.userLocation = newLocation

        if isLocationInitialized == false {
            fetchVenues(newLocation.coordinate)
            isLocationInitialized = true
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return FoursquareManager.sharedManager().venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as UITableViewCell
        let venue = FoursquareManager.sharedManager().venues[(indexPath as NSIndexPath).row]

        // Configure the cell...
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = venue.location.address
        cell.imageView?.sd_cancelCurrentAnimationImagesLoad()

        var categoryIconURL: URL? = nil
        if let categories = venue.categories {
            if !categories.isEmpty {
                categoryIconURL = URL(string: categories[0].icon.categoryIconUrl)
            }
        }
        cell.imageView?.sd_setImage(with: categoryIconURL, placeholderImage: UIImage(named: "none"))

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let currentLocation = userLocation {
            let venue = FoursquareManager.sharedManager().venues[(indexPath as NSIndexPath).row]

            // checkin
            FoursquareManager.sharedManager().checkinWithVenueId(venue.venueId, location: currentLocation, completion:
                { [weak self] checkin, error in
                    if let error = error {
                        let alertController =
                            UIAlertController(title: "Checkin failed",
                                              message: error.localizedDescription,
                                              preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction =
                            UIAlertAction(title: "Close",
                                          style: UIAlertActionStyle.cancel,
                                          handler: nil)
                        alertController.addAction(cancelAction)
                        self?.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController =
                            UIAlertController(title: "Checkin success",
                                              message: checkin?.venue.name,
                                              preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction: UIAlertAction =
                            UIAlertAction(title: "Close",
                                          style: UIAlertActionStyle.cancel,
                                          handler: nil)
                        alertController.addAction(cancelAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            )
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
